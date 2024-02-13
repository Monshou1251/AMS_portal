<template>
  <div class="file-uploader">
    <h3 class="title">Деактивация проводок закрытия периода</h3>
    <div class="content" style="height:413px; overflow-y: auto; border-radius: 5px;">
      <ag-grid-vue
        style="width: 100%; height: 100%"
        class="ag-theme-alpine"
        :rowHeight="30"
        :sizeColumnsToFit="true"
        :columnDefs="columnDefs"
        :rowData="rowData"
        :gridOptions="gridOptions"
        :defaultColDef="defaultColDef"
        @row-selected="onRowSelected"
      >
      </ag-grid-vue>
    </div>
    <div
      class="upload-button"
      @click="sendDataToBackend"
      :class="{ 'active-effect': isActive }"
      @mousedown="handleMouseDown"
      @mouseup="handleMouseUp"
      >
      Выполнить деактивацию
    </div>
    <div class="content">
      <div class="log-panel">
        <div
          class="refresh-button"
          @click="refreshLog"
        >
          <svg-icon
            type="mdi"
            :path="mdiDeleteOutline"
            class="icon-reload"
          ></svg-icon>
        </div>
      </div>
      <div class="content-right" ref="logContainer">
          
          <div v-for="(message, index) in logMessages" :key="index"  :class="message.class">
            <div class="log-text">
              {{ message.timestamp }} - {{ message.text }}
            </div>
          </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, nextTick } from "vue";
// import { useStore } from "vuex";
import { onMounted } from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
import {
  mdiFolderUploadOutline,
  mdiNotificationClearAll,
  mdiTable,
  mdiSendVariantOutline,
  mdiViewListOutline,
  mdiDeleteOutline,
} from "@mdi/js";
import axios from "axios";
import { AgGridVue } from "ag-grid-vue3";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-alpine.css";

export default {
  name: "fileUploader",
  components: {
    SvgIcon,
    AgGridVue,
  },

  setup() {
    // const store = useStore();

    const selectedFile = ref(null);
    const selectedFileName = ref(null);
    const selectedSheet = ref([]);
    const selectedSheetNames = ref([]);
    const selectedSchema = ref("AMS_GL");
    const selectedTable = ref("XLSX_DGL_BUFFER");
    const isActive = ref(false);
    const logMessages = ref([]);
    const logContainer = ref(null);
    const rowData = ref([]);
    const gridApi = ref()
    const dataToSend = ref()
    const isLoading = ref(false);

    const onGridReady = (params) => {
      gridApi.value = params.api
    }

    const gridOptions = ref({
      // domLayout: 'autoHeight',
      pagination: true,
      paginationPageSize: 10,
      rowSelection: "single",
      
      // overlayLoadingTemplate: '<span'
    })

    const defaultColDef = ref({
      resizable: true,
    })

    const onRowSelected = (event) => {
      if (event.node.isSelected()) {
        dataToSend.value = event.data
      }
    }

    const loading = ref(false)
    const columnDefs = ref([
      { headerName:'Содержание пакета проводок', field: 'SOURCE_FILE_NAME', flex: 1, sortable: true, filter: true},
      // { headerName:'Лист файла-источника', field: 'SHEET_NAME', flex: 1, sortable: true, filter: true},
      { headerName:'Пользователь', field: 'USER_NAME', flex: 1, sortable: true, filter: true},
      { headerName:'Дата', field: 'LOAD_TIMESTAMP', flex: 1, sortable: true, filter: true},
      { headerName:'Число проводок', field: 'ROWS_COUNT', flex: 1, sortable: true, filter: true},
      // { headerName:'Содержание пакета проводок', field: 'ENTRIES_BATCH_CONTENT', flex: 1, sortable: true, filter: true},
    ])

    // Добавление сообщений в окно лога
    const addLogMessage = (text, status = 'info') => {
      const timestamp = new Date().toLocaleTimeString();
      const isSuccess = status === "success";
      const isError = status === "error";

      logMessages.value.push({
        timestamp,
        text,
        class: isError ? 'log-error' : (isSuccess ? 'log-success' : 'log-info'),
      });

      if (logMessages.value.length > 100) {
        logMessages.value.shift();
      }
      nextTick(() => {
        logContainer.value.scrollTop = logContainer.value.scrollHeight;
      });
    };


    const refreshLog = () => {
      logMessages.value = null
    }

    const handleMouseDown = () => {
      isActive.value = true;
    };
    const handleMouseUp = () => {
      isActive.value = false;
    };

    const getData = async () => {
      try {
        isLoading.value = true;
        const retreiveTransferList = await axios.get("/get_transfer_list_ams", getData)

        if (retreiveTransferList.status === 200) {
          const data = retreiveTransferList.data.message
          rowData.value = data
          isLoading.value = false;
        } else {
          alert("Failed to retrieve sheet names from the server.");
          isLoading.value = false;
        }
      }
      catch (error) {
        console.log(error)
        isLoading.value = false;
      }
    }

    const sendDataToBackend = async () => {
      if (dataToSend.value) {
        try {
          addLogMessage('Выполняется деактивация загруженных из выбранного файла проводок.')
          console.log(dataToSend.value)
          const response = await axios.post('/xlsx_deactivate_ams', dataToSend.value)
          if (response.status === 200) {
            const message = response.data.message
            addLogMessage(message, 'success')
          } else {
            addLogMessage('Возникла ошибка про попытке деактивации проводки', 'error')
          }
          getData()
        } catch (error) {
          console.log(error)
        }
      } else {
        console.warn('No data to send')
        addLogMessage('Выберите проводку для деактивации', 'error')
      }
    }
    
    onMounted(() => {
      getData()
    })

    return {
      selectedFile,
      mdiFolderUploadOutline,
      mdiNotificationClearAll,
      mdiDeleteOutline,
      mdiTable,
      selectedSchema,
      selectedTable,
      mdiSendVariantOutline,
      loading,
      isActive,
      logMessages,
      logContainer,
      selectedFileName,
      mdiViewListOutline,
      selectedSheetNames,
      selectedSheet,
      refreshLog,
      handleMouseDown,
      handleMouseUp,
      columnDefs,
      rowData,
      gridOptions,
      onRowSelected,
      onGridReady,
      sendDataToBackend,
      isLoading,
      defaultColDef,
    };
  },
};
</script>

<style scoped>
.file-uploader {
  /* padding: 20px; */
  padding-left: 30px;
  padding-right: 30px;
  padding-top: 10px;
  padding-bottom: 20px;
}

.title {
  padding-bottom: 20px;
}

.content {
  width: 100%;
  font-size: 14px;
  padding-bottom: 10px;
}

.ag-theme-alpine {
  --ag-header-height: 45px;
  --ag-foreground-color: #444746;
  --ag-header-foreground-color: #444746;
  --ag-secondary-foreground-color: #444746;
  --ag-borders: solid 1px;
  /* then add back a border between rows */
  --ag-borders-row: dashed 1px;
  --ag-row-border-color: rgba(131, 128, 128, 0.308);
  --ag-cell-horizontal-border: solid 1px rgba(128, 128, 131, 0.288);
  --ag-widget-container-horizontal-padding: 1px;
  --ag-widget-container-vertical-padding: 1px;
  --ag-border-color: rgba(131, 128, 128, 0.181);
  --ag-borders: solid 1px;
  --ag-border-width: 1px;
  /* --ag-borders-secondary: dashed; */
  --ag-font-family: system-ui, serif;
  --ag-header-cell-hover-background-color: rgba(234, 243, 245, 0.722);
  --ag-row-hover-color: rgba(234, 243, 245, 0.722);
  --ag-header-column-resize-handle-height: 100%;
  --ag-header-column-resize-handle-width: 1px;
  --ag-header-column-separator-display: block;
  --ag-header-column-separator-height: 100%;
  --ag-header-column-separator-width: 1px;
  --ag-header-column-separator-color: rgba(131, 128, 128, 0.181);
  --ag-cell-horizontal-padding: 10px;
}

.ag-theme-alpine .ag-cell-last-left-pinned {
  border-right: none;
}
.ag-theme-alpine .ag-cell-last-left-pinned {
  background-color: transparent;
}

.content-right {
  position: relative;
  height: 200px;
  width: 800px;
  background-color: white;
  border-radius: 5px;
  overflow-y: auto;
  margin-top: 10px;
}

.log-text {
  padding-left: 10px;
}


/* Button to send data to backend */
.upload-button {
  display: flex;
  justify-content: center;
  gap: 10px;
  text-align: center;
  background-color: white;
  box-shadow: 0 1px 2px #00000080;
  width: 210px;
  height: 35px;
  border-radius: 2px;
  cursor: pointer;
  align-items: center;
  font-weight: 600;
  transition: box-shadow 0.3s ease-in-out;
  font-size: 14px;

  &:hover {
    background-color: #44474611;
  }
  &.active-effect {
    box-shadow: inset 0 1px 2px #00000080;
  }
}


/* Button for reloading log window */
.log-panel {
  position: relative;
  /* right: 0; */
  display: flex;
  /* justify-content: flex-end; */
  margin-top: -5px;
  margin-bottom: -5px;
  margin-left: 777px;
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


.log-success {
  background-color: #b1cbbbe2;
}

.log-error {
  background-color: #f7796bd8;
}




/* customize scroll bar */
::-webkit-scrollbar {
  width:8px
}

::-webkit-scrollbar-thumb {
  background-color: #888;
  border-radius: 4px;
}

::-webkit-scrollbar-track {
  background-color: #f1f1f1;
}

/* loading visualization when data is loading in the table */
.spinner-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%; 
  margin-top: 20%;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-left-color: #1a73e8;
  border-radius: 50%;
  animation: spin 1s infinite linear;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

</style>
