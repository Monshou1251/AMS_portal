<template>
  <div class="file-uploader">
    <h2 class="title">Выгрузка данных из Excel</h2>

    <div class="content">
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
              :path="mdiNotificationClearAll"
              class="icon-upload"
            ></svg-icon>
            Название схемы
          </div>

          <div class="input-info">{{ selectedSchema }}</div>
        </div>
        <div class="input-area">
          <div class="info-field">
            <svg-icon
              type="mdi"
              :path="mdiTable"
              class="icon-upload"
            ></svg-icon>
            Название таблицы
          </div>

          <div class="input-info">{{ selectedTable }}</div>
        </div>
        <div class="input-area">
          <div
            class="upload-button"
            :class="{ 'active-effect': isActive }"
            @mousedown="handleMouseDown"
            @mouseup="handleMouseUp"
            @click="uploadFile"
          >
            <svg-icon
              type="mdi"
              :path="mdiSendVariantOutline"
              class="icon-upload"
            ></svg-icon>
            Отправить данные
          </div>
        </div>
        <div class="content-right" ref="logContainer">
          <div class="log-window">
            <div v-for="(message, index) in logMessages" :key="index">
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
import SvgIcon from "@jamescoyle/vue-icon";
import {
  mdiFolderUploadOutline,
  mdiNotificationClearAll,
  mdiTable,
  mdiSendVariantOutline,
  mdiViewListOutline,
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
    const selectedFile = ref(null);
    const selectedFileName = ref(null);
    const selectedSheet = ref([]);
    const selectedSheetNames = ref([]);
    const selectedSchema = ref("AMS_TMP");
    const selectedTable = ref("073_Мэппинг АВС");
    const isActive = ref(false);
    const logMessages = ref([]);
    const logContainer = ref(null);

    const addLogMessage = (text) => {
      const timestamp = new Date().toLocaleTimeString();
      logMessages.value.push({ timestamp, text });

      if (logMessages.value.length > 100) {
        logMessages.value.shift();
      }
      nextTick(() => {
        logContainer.value.scrollTop = logContainer.value.scrollHeight;
      });
    };

    const handleMouseDown = () => {
      isActive.value = true;
    };
    const handleMouseUp = () => {
      isActive.value = false;
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

    const uploadFile = async () => {
      if (!selectedFile.value) {
        const errorMessage = "Выберите файл для выгрузки.";
        addLogMessage(errorMessage);
        console.error(errorMessage);
        return;
      }

      const formData = new FormData();
      console.log(selectedFile.value);
      formData.append("file", selectedFile.value);
      formData.append("sheet", selectedSheet.value);
      formData.append("schema", selectedSchema.value);
      formData.append("table", selectedTable.value);

      try {
        addLogMessage("Отправка данных...");
        const response = await axios.post("/excel_uploader", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        });

        if (response.status === 200) {
          //   const successMessage = "File uploaded successfully!";
          if (response.data.error) {
            addLogMessage(response.data.error);
          } else {
            addLogMessage(response.data.message);
          }
        } else {
          console.error("Failed to upload file.");
        }
      } catch (error) {
        addLogMessage(error);
      }
    };

    return {
      selectedFile,
      uploadFile,
      openFileDialog,
      mdiFolderUploadOutline,
      mdiNotificationClearAll,
      mdiTable,
      selectedSchema,
      selectedTable,
      mdiSendVariantOutline,
      isActive,
      handleMouseDown,
      handleMouseUp,
      logMessages,
      logContainer,
      selectedFileName,
      mdiViewListOutline,
      selectedSheetNames,
      selectedSheet,
    };
  },
};
</script>

<style scoped>
.file-uploader {
  /* padding: 20px; */
  padding-left: 30px;
  padding-top: 20px;
}

.title {
  padding-bottom: 20px;
}

.content {
  width: 500px;
  font-size: 14px;
}

.content-left {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.content-right {
  height: 150px;
  width: auto;
  background-color: #f9f7f3;
  border-radius: 5px;
  padding-left: 10px;
  overflow-y: auto;
}

.input-area {
  display: flex;
  flex-direction: row;
  gap: 10px;
}

.input-info {
  display: flex;
  flex: 1;
  background-color: #f9f7f3;
  border-radius: 5px;
  white-space: nowrap;
  padding-left: 10px;
  align-items: center;
  color: #333;
}

.input-info-list {
  display: flex;
  flex: 1;
  background-color: #f9f7f3;
  border-radius: 5px;
  white-space: nowrap;
  padding-left: 6px;
  align-items: center;
  color: #333;
}

.input-droplist {
  display: flex;
  flex: 1;
  background-color: #f9f7f3;
  border-radius: 5px;
  white-space: nowrap;
  align-items: center;
  justify-content: center;
  height: 25px;
  width: auto;
  border: none;
  padding-left: -55px;
}

select {
  background-color: #f9f7f3;
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
  background-color: #f9f7f3;
  box-shadow: 0 1px 2px #00000080;
  width: 200px;
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
  background-color: #f9f7f3;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
  width: 200px;
  height: 25px;
  border-radius: 5px;
  align-items: center;
  font-weight: 600;
}

.icon-upload {
  margin-left: 5px;
}
</style>
