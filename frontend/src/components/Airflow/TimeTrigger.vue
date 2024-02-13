<template>
  <div class="file-uploader">
    <h2 class="title">Запуск Airflow DAG</h2>

    <div class="content">
      <div class="content-left">
        <div class="input-area">
          <div class="info-field">
            <svg-icon
              type="mdi"
              :path="mdiNotificationClearAll"
              class="icon-upload"
            ></svg-icon>
            DAG name
          </div>

          <div class="input-info">{{ DAGname }}</div>
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
            Trigger DAG
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
  
  export default {
    name: "timeTrigger",
    components: {
      SvgIcon,
    },
  
    setup() {
      const selectedSheet = ref([]);
      const selectedSheetNames = ref([]);
      // const DAGname = ref("test_time_delta_sensor");
      const DAGname = ref("test_xlsx_load");
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

      const uploadFile = async () => {

        try {
          addLogMessage("Отправка данных...");
          const response = await axios.post('trigger_time_delta');

          if (response.status === 200) {
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
  
      const handleMouseDown = () => {
        isActive.value = true;
      };
      const handleMouseUp = () => {
        isActive.value = false;
      };
  
      return {
        mdiFolderUploadOutline,
        mdiNotificationClearAll,
        mdiTable,
        DAGname,
        mdiSendVariantOutline,
        isActive,
        handleMouseDown,
        handleMouseUp,
        logMessages,
        logContainer,
        mdiViewListOutline,
        selectedSheetNames,
        selectedSheet,
        uploadFile,
      };
    },
  };
  </script>

<style scoped>
    .file-uploader {
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