<template>
  <div class="file-uploader">
    <div class="content">
      <h2 class="title">Импорт проводок из MS EXCEL в AMS</h2>
      <div class="content-left">
        <div class="input-area">
          <div class="upload-button" @click="openFileDialog">
            <svg-icon
              type="mdi"
              :path="mdiFolderUploadOutline"
              :class="{ 'active-effect': isActive }"
              @mousedown="handleMouseDown"
              @mouseup="handleMouseUp"
              @click="openFileDialog"
              class="icon-upload"
            ></svg-icon>
            Выберите файл
          </div>

          <div class="input-info">{{ selectedFileName }}</div>
        </div>
        <div class="input-area">
          <div class="info-field">
            <svg-icon
              type="mdi"
              :path="mdiViewListOutline"
              class="icon-upload"
            ></svg-icon>
            Лист Excel
          </div>
          <div class="input-info-list">
            <select class="input-droplist" v-model="selectedSheet">
              <option class="input-option" value="" disabled>
                Select a sheet
              </option>
              <option
                v-for="(sheetName, index) in selectedSheetNames"
                :value="sheetName"
                :key="index"
              >
                {{ sheetName }}
              </option>
            </select>
          </div>
        </div>
        <div class="input-area">
          <div class="info-field">
            <svg-icon
              type="mdi"
              :path="mdiTextBoxEditOutline"
              class="icon-upload"
            ></svg-icon>
            Содержание пакета проводок
          </div>
          <div class="input-info-list">
            <input class="input-field" type="text" v-model="batchContent" />
          </div>
        </div>
        <div class="input-area">
          <div class="buttons-field">
            <div
              class="upload-button-checks"
              :class="{ 'active-effect': isActive1 }"
              @mousedown="handleMouseDown1"
              @mouseup="handleMouseUp1"
              @click="uploadFile"
            >
              <div class="buttons-text" v-if="!loading1">Загрузить в буфер</div>
              <div class="loader" v-if="loading1"></div>
            </div>
            <div
              v-show="showCheckButton"
              class="upload-button-checks"
              :class="{ 'active-effect': isActive2 }"
              @mousedown="handleMouseDown2"
              @mouseup="handleMouseUp2"
              @click="checkFiles"
            >
              <!-- <svg-icon
                type="mdi"
                :path="mdiSendVariantOutline"
                class="icon-upload"
              ></svg-icon> -->
              <div class="buttons-text" v-if="!loading2">Проверить данные</div>
              <div class="loader" v-if="loading2"></div>
            </div>
            <div
              v-show="showPushButton"
              class="upload-button-checks"
              :class="{ 'active-effect': isActive3 }"
              @mousedown="handleMouseDown3"
              @mouseup="handleMouseUp3"
              @click="pushFiles"
            >
              <!-- <svg-icon
                type="mdi"
                :path="mdiSendVariantOutline"
                class="icon-upload"
              ></svg-icon> -->
              <div class="buttons-text" v-if="!loading3">
                Загрузить проводки
              </div>
              <div class="loader" v-if="loading3"></div>
            </div>
          </div>
        </div>
        <div class="log-panel">
          <div class="refresh-button" @click="refreshLog">
            <svg-icon
              type="mdi"
              :path="mdiDeleteOutline"
              class="icon-reload"
            ></svg-icon>
          </div>
        </div>
        <div class="content-right" ref="logContainer">
          <div
            v-for="(message, index) in logMessages"
            :key="index"
            :class="message.class"
          >
            <div class="log-text">
              {{ message.timestamp }} - {{ message.text }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, nextTick } from "vue";
import { useStore } from "vuex";
import { computed } from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
import {
  mdiFolderUploadOutline,
  mdiNotificationClearAll,
  mdiTable,
  mdiSendVariantOutline,
  mdiViewListOutline,
  mdiDeleteOutline,
  mdiTextBoxEditOutline,
} from "@mdi/js";
import axios from "axios";
// import { read } from "xlsx";
// import XLSX from "xlsx";
// import * as XLSX from "xlsx";

export default {
  name: "fileUploader",
  components: {
    SvgIcon,
  },

  setup() {
    const store = useStore();

    const selectedFile = ref(null);
    const selectedFileName = ref(null);
    const selectedSheet = ref([]);
    const selectedSheetNames = ref([]);
    const selectedSchema = ref("AMS_GL");
    const selectedTable = ref("XLSX_DGL_BUFFER");
    const isActive = ref(false);
    const isActive1 = ref(false);
    const isActive2 = ref(false);
    const isActive3 = ref(false);
    const logMessages = ref([]);
    const logContainer = ref(null);
    const currentUser = computed(() => store.state.currentUser);
    const username = computed(() => {
      const email = currentUser.value;
      return email.split("@")[0];
    });
    const batchContent = ref("");

    const showCheckButton = ref(false);
    const showPushButton = ref(false);
    const loading1 = ref(false);
    const loading2 = ref(false);
    const loading3 = ref(false);

    const addLogMessage = (text, status = "info") => {
      const timestamp = new Date().toLocaleTimeString();
      const isSuccess = status === "success";
      const isError = status === "error";

      logMessages.value.push({
        timestamp,
        text,
        class: isError ? "log-error" : isSuccess ? "log-success" : "log-info",
      });

      if (logMessages.value.length > 100) {
        logMessages.value.shift();
      }
      nextTick(() => {
        logContainer.value.scrollTop = logContainer.value.scrollHeight;
      });
    };

    const refreshLog = () => {
      logMessages.value = [];
    };

    const handleMouseDown = () => {
      isActive.value = true;
    };
    const handleMouseUp = () => {
      isActive.value = false;
    };
    const handleMouseDown1 = () => {
      isActive1.value = true;
    };
    const handleMouseUp1 = () => {
      isActive1.value = false;
    };

    const handleMouseDown2 = () => {
      isActive2.value = true;
    };
    const handleMouseUp2 = () => {
      isActive2.value = false;
    };

    const handleMouseDown3 = () => {
      isActive3.value = true;
    };
    const handleMouseUp3 = () => {
      isActive3.value = false;
    };

    const openFileDialog = async () => {
      const input = document.createElement("input");
      input.type = "file";
      input.accept = ".xlsx, .xls";

      input.onchange = async (event) => {
        const file = event.target.files[0];

        if (file) {
          const fileName = file.name;
          const fileExtension = fileName.split(".").pop().toLowerCase();
          if (fileExtension === "xlsx" || fileExtension === "xls") {
            selectedFile.value = file;
            selectedFileName.value = file.name;
            showCheckButton.value = false;
            showPushButton.value = false;

            const formData = new FormData();
            formData.append("excelFile", file);

            try {
              const response = await axios.post(
                "/retrieve_sheet_names",
                formData,
                {
                  headers: {
                    "Content-Type": "multipart/form-data",
                  },
                }
              );

              if (response.status === 200) {
                const data = response.data;
                console.log(data);
                selectedSheetNames.value = data.sheetNames;
              } else {
                alert("Failed to retrieve sheet names from the server.");
              }
            } catch (error) {
              console.error("Error sending the file to the server:", error);
            }
          } else {
            alert("Please choose an Excel file.");
          }
        }
      };
      input.click();
    };

    async function writeToExasol(formData) {
      try {
        // addLogMessage("Выполняется загрузка проводок из выбранного файла в буферную таблицу...");
        const response = await axios.post("/xlsx_to_exa_table", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        });

        if (response.status === 200) {
          if (response.data.error) {
            addLogMessage(response.data.error, "error");
          } else {
            addLogMessage(response.data.message, "success");
            showCheckButton.value = true;
          }
        } else {
          console.error("Failed to upload file.");
        }
      } catch (error) {
        addLogMessage(error, "error");
      }
    }

    async function deleteFromExasol(formData) {
      try {
        const response = await axios.post(
          "/xlsx_to_exa_delete_from_buffer",
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );

        if (response.status === 200) {
          if (response.data.error) {
            addLogMessage(response.data.error, "error");
          } else {
            addLogMessage(response.data.message, "success");
          }
        } else {
          console.log("Не удалось удалить данные из таблицы.");
        }
      } catch (error) {
        addLogMessage(error, "error");
      }
    }

    const uploadFile = async () => {
      if (!selectedFile.value) {
        const errorMessage = "Выберите файл для выгрузки.";
        addLogMessage(errorMessage, "error");
        return;
      } else if (selectedSheet.value == 0) {
        const errorMessage = "Выберите лист для выгрузки.";
        addLogMessage(errorMessage, "error");
        return;
      } else if (batchContent.value.trim() == "") {
        const errorMessage = 'Заполните поле "Содержание пакета проводок".';
        addLogMessage(errorMessage, "error");
        return;
      } else {
        const formData = new FormData();
        formData.append("file", selectedFile.value);
        formData.append("sheet", selectedSheet.value);
        formData.append("schema", selectedSchema.value);
        formData.append("table", selectedTable.value);
        formData.append("username", username.value);

        try {
          addLogMessage(
            "Выполняется загрузка проводок из выбранного файла в буферую таблицу..."
          );

          // send the request to check if provided data already exists in the buffer table
          loading1.value = true;
          const checkBuffer = await axios.post(
            "/xlsx_to_exa_check_DGL_ENTRY",
            formData
          );

          if (checkBuffer.status === 200) {
            const rowsAmount = checkBuffer.data.message;
            console.log("rowsAmount");
            console.log(rowsAmount);

            if (rowsAmount === 0) {
              try {
                await deleteFromExasol(formData);
                const response = await axios.post(
                  "/xlsx_to_exa_table",
                  formData,
                  {
                    headers: {
                      "Content-Type": "multipart/form-data",
                    },
                  }
                );

                if (response.status === 200) {
                  if (response.data.error) {
                    addLogMessage(response.data.error, "error");
                    loading1.value = false;
                  } else {
                    addLogMessage(response.data.message, "success");
                    showCheckButton.value = true;
                    loading1.value = false;
                  }
                } else {
                  console.error("Failed to upload file.");
                  loading1.value = false;
                }
              } catch (error) {
                addLogMessage(error, "error");
                loading1.value = false;
              }
            } else {
              const userWantsToContinue = window.confirm(
                `Проводки из выбранного Excel файла уже были загружены под вашей учетной записью в детальную главную книгу. Следующее количество проводок из файла уже находятся в таблице ДГК: ${rowsAmount}. Загрузить в буферную таблицу проводки из выбранного файла?`
              );

              if (userWantsToContinue) {
                await deleteFromExasol(formData);
                await writeToExasol(formData);
                loading1.value = false;
              } else {
                addLogMessage("Загрузка данных в буферную таблицу отменена.");
                loading1.value = false;
                return;
              }
            }
          }
        } catch (error) {
          addLogMessage(error, "error");
          loading1.value = false;
        }
      }
    };

    const checkFiles = async () => {
      const formData = new FormData();
      console.log(selectedFile.value);
      formData.append("file", selectedFile.value);
      formData.append("sheet", selectedSheet.value);
      formData.append("schema", selectedSchema.value);
      formData.append("table", selectedTable.value);
      formData.append("username", username.value);
      formData.append("batch", batchContent.value);

      try {
        addLogMessage(
          "Выполняется проверка загруженных в буферную таблицу проводок на \
        наличие ошибок..."
        );
        loading2.value = true;
        const response = await axios.post(
          "/xlsx_to_exa_table_check",
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );

        if (response.status === 200) {
          if (response.data.error) {
            addLogMessage(response.data.error, "error");
            loading2.value = false;
          } else {
            showPushButton.value = true;
            loading2.value = false;
            addLogMessage(response.data.message, "success");
          }
        } else {
          console.error("Не удалось запустить проверку.");
          loading2.value = false;
        }
      } catch (error) {
        addLogMessage(error, "error");
        loading2.value = false;
      }
    };

    const pushFiles = async () => {
      const formData = new FormData();
      console.log(selectedFile.value);
      formData.append("file", selectedFile.value);
      formData.append("sheet", selectedSheet.value);
      formData.append("schema", selectedSchema.value);
      formData.append("table", selectedTable.value);
      formData.append("username", username.value);
      formData.append("batch", batchContent.value);

      try {
        addLogMessage(
          "Выполняется загрузка проводок из буферной таблицы в детальную\
         главную книгу..."
        );
        loading3.value = true;

        const response = await axios.post("/xlsx_to_exa_table_push", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        });

        if (response.status === 200) {
          //   const successMessage = "File uploaded successfully!";
          if (response.data.error) {
            addLogMessage(response.data.error, "error");
            loading3.value = false;
          } else {
            addLogMessage(response.data.message, "success");
            loading3.value = false;
            showPushButton.value = false;
            showCheckButton.value = false;
          }
        } else {
          addLogMessage("Не удалось записать данные.", "error");
          loading3.value = false;
        }
      } catch (error) {
        addLogMessage(error, "error");
        loading3.value = false;
      }
    };

    return {
      selectedFile,
      uploadFile,
      checkFiles,
      openFileDialog,
      mdiFolderUploadOutline,
      mdiNotificationClearAll,
      mdiDeleteOutline,
      mdiTable,
      selectedSchema,
      selectedTable,
      mdiSendVariantOutline,
      isActive,
      isActive1,
      isActive2,
      isActive3,
      loading1,
      loading2,
      loading3,
      handleMouseDown,
      handleMouseUp,
      handleMouseDown1,
      handleMouseUp1,
      handleMouseDown2,
      handleMouseUp2,
      handleMouseDown3,
      handleMouseUp3,
      logMessages,
      logContainer,
      selectedFileName,
      mdiViewListOutline,
      selectedSheetNames,
      selectedSheet,
      showCheckButton,
      showPushButton,
      pushFiles,
      refreshLog,
      batchContent,
      mdiTextBoxEditOutline,
    };
  },
};
</script>

<style scoped>
.file-uploader {
  /* padding: 20px; */
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding-left: 30px;
  padding-right: 30px;
  padding-top: 10px;
}

.title {
  padding-bottom: 20px;
  /* margin-left: 10px; */
  /* left: -20px;
  display: flex;
  justify-content: flex-start;
  align-items: flex-start; */
}

.content {
  width: 700px;
  font-size: 14px;
}

.content-left {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-thumb {
  background-color: #888;
  border-radius: 4px;
}

::-webkit-scrollbar-track {
  background-color: #f1f1f1;
}

.log-text {
  padding-left: 10px;
}

.input-area {
  display: flex;
  flex-direction: row;
  gap: 10px;
}

.input-info {
  display: flex;
  flex: 1;
  background-color: white;
  border-radius: 5px;
  white-space: nowrap;
  padding-left: 10px;
  align-items: center;
  color: #333;
  overflow: hidden;
}

.input-info-list {
  display: flex;
  flex: 1;

  background-color: white;
  border-radius: 5px;
  white-space: nowrap;
  padding-left: 6px;
  align-items: center;
  color: #333;
}

.input-droplist {
  display: flex;
  flex: 1;
  background-color: white;
  border-radius: 5px;
  white-space: nowrap;
  align-items: center;
  justify-content: center;
  height: 20px;
  width: auto;
  border: none;
  padding-left: -55px;
}

select {
  background-color: white;
  color: #333;
  height: 30px;
  border-radius: 5px;
  border: 1px solid #333;
  /* -webkit-appearance: none; */
  /* appearance: none; */
}

.input-droplist:focus {
  box-shadow: 0 0 0px 0px #ccc;
  outline: none;
}

.input-option {
  color: #333;
  border-radius: 5px;
}

.upload-button {
  display: flex;
  gap: 10px;
  background-color: white;
  box-shadow: 0 1px 2px #00000080;
  width: 250px;
  height: 25px;
  border-radius: 5px;
  cursor: pointer;
  align-items: center;
  font-weight: 600;
  transition: box-shadow 0.3s ease-in-out;

  &:hover {
    background-color: #44474611;
  }
  &.active-effect {
    box-shadow: inset 0 1px 2px #00000080;
  }
}

.info-field {
  display: flex;
  gap: 10px;
  background-color: white;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
  width: 250px;
  height: 25px;
  border-radius: 5px;
  align-items: center;
  font-weight: 600;
}

.upload-button-checks {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  background-color: white;
  box-shadow: 0 1px 2px #00000080;
  flex: 1;
  width: 100%;
  height: 100%;
  max-width: 33%;
  box-sizing: border-box;
  border-radius: 5px;
  cursor: pointer;

  font-weight: 600;
  transition: box-shadow 0.3s ease-in-out;

  &:hover {
    background-color: #44474611;
  }
  &.active-effect {
    box-shadow: inset 0 1px 2px #00000080;
  }
}

.content-right {
  position: relative;
  height: 250px;
  width: auto;
  background-color: white;
  border-radius: 5px;
  overflow-y: auto;
}

/* input batch-content */
.input-field {
  width: 98%;
  height: 90%;
  border: none;
  outline: none;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
    Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
  font-weight: 600;
  color: #444746;
}

/* Button for reloading log window */
.log-panel {
  position: relative;
  display: flex;
  justify-content: flex-end;
  margin-top: -16px;
  margin-bottom: -5px;
  bottom: -27px;
  z-index: 1;
}

.refresh-button {
  display: flex;
  margin-top: -10px;
  justify-content: center;
  /* position:sticky; */
  opacity: 60%;
  background-color: #f9f7f3;
  box-shadow: 0 1px 2px #00000080;
  width: 22px;
  height: 22px;
  box-sizing: border-box;
  border-radius: 5px;
  cursor: pointer;
  align-items: center;
  font-weight: 600;
  transition: box-shadow 0.3s ease-in-out;

  &:hover {
    background-color: #f9f7f3;
    opacity: 1;
  }
  &.active-effect {
    box-shadow: inset 0 1px 2px #00000080;
  }
}

.icon-reload {
  scale: 90%;
}

.icon-upload {
  margin-left: 5px;
}

.buttons-field {
  display: flex;
  padding: 7px;
  gap: 7px;
  background-color: white;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
  width: 100%;
  height: 55px;
  border-radius: 5px;
  align-items: center;
  font-weight: 600;
}

.buttons-text {
  text-align: center;
}

.log-success {
  background-color: #b1cbbbe2;
}

.log-error {
  background-color: #f7796bd8;
}

.loader {
  width: 90px;
  height: 30px;
  display: grid;
  overflow: hidden;
  /* scale: 70%; */
  /* transform: scale(0.7);
  transform-origin: center center; */
}

.loader:before,
.loader:after {
  content: "";
  grid-area: 1/1;
  background: #11656659;
  /* background: #2c3531a0; */
  clip-path: polygon(
    0 10px,
    calc(100% - 15px) 10px,
    calc(100% - 15px) 0,
    100% 50%,
    calc(100% - 15px) 100%,
    calc(100% - 15px) calc(100% - 10px),
    0 calc(100% - 10px)
  );

  animation: l5 2s infinite;
  transform: translate(calc(0% + var(--s, 0%)));
}

.loader:after {
  --s: -100%;
}

@keyframes l5 {
  80%,
  100% {
    transform: translate(calc(100% + var(--s, 0%)));
  }
}
</style>
