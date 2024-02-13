<template>
  <div class="file-uploader">

    <div class="content">
      <h2 class="title">Генерация проводок закрытия периода</h2>
      <div class="content-left">
        <div class="input-area">
          <div class="info-field">
            <svg-icon
              type="mdi"
              :path="mdiCalendarBlankOutline"
              class="icon-upload"
            ></svg-icon>
            Введите дату
          </div>
          <!-- <div class="input-info-list"> -->
            <input class="input-field" type="text" v-model="genDate">
          <!-- </div> -->
        </div>
        <div class="input-area">
          <button class="gen-button" @click="sendDataToBackend">
            Сгенерировать проводки
          </button>
        </div>
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
  </div>
</template>

<script setup>
import { ref, nextTick } from "vue";
// import { computed } from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
import {
  mdiCalendarBlankOutline,
  mdiDeleteOutline,
} from "@mdi/js";
import axios from "axios";

const genDate = ref('')
const logMessages = ref([]);
const logContainer = ref(null);

const sendDataToBackend = async () => {
  if (!genDate.value) {
    addLogMessage('Выберите дату генерации проводки', 'error')
    return
  }

  const datePattern = /^\d{4}-\d{2}-\d{2}$/

  if (!datePattern.test(genDate.value)) {
    addLogMessage('Неверный формат даты. Используйте формат YYYY-MM-DD.', 'error')
    return
  }

  try {
    addLogMessage('Выполняется генерация проводки закрытия периода.')
    const response = await axios.post('/generate_transfer', { date: genDate.value } )
    if (response.status === 200) {
      const message = response.data.message
      addLogMessage(message, 'success')
    } else {
      addLogMessage('Возникла ошибка про попытке генерации проводки', 'error')
    }
  } catch (error) {
    console.log(error)
    addLogMessage('Ошибка при отправке данных на сервер', 'error')
  }
}


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
  logMessages.value = []
}


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
  width:8px
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
  align-items: center;
  flex-direction: row;
  gap: 10px;
}

.input-info {
  display: flex;
  flex: 1;
  background-color: white;
  border-radius: 2px;
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
  border-radius: 2px;
  white-space: nowrap;
  padding-left: 6px;
  align-items: center;
  color: #333;
}


.info-field {
  display: flex;
  gap: 10px;
  background-color: white;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
  width: 200px;
  height: 25px;
  border-radius: 2px;
  align-items: center;
  font-weight: 600;
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
  width: 200px;
  height: 23px;
  /* margin: 5px; */
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
  border: none;
  outline: none;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  font-weight: 600;
  color: #444746;
  border-radius: 2px;
}

.gen-button {
  border: none;
  cursor: pointer;
  height: 25px;
  width: 200px;
  background-color: white;
  box-shadow:  0 1px 2px rgba(0, 0, 0, 0.2);
  border-radius: 2px;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  font-weight: 600;
  color: #444746;
}

.gen-button:hover {
  background-color: #33333311;
}

.gen-button:active {
  background-color: #33333326;
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
  scale: 0.8;
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
  display:  grid;
  overflow:hidden;
  /* scale: 70%; */
  /* transform: scale(0.7);
  transform-origin: center center; */
}

 
.loader:before,

.loader:after {
  content: "";
  grid-area:1/1;
  background: #11656659;
  /* background: #2c3531a0; */
  clip-path:polygon(
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
  80%, 100% {transform: translate(calc(100% + var(--s,0%)))}
}

</style>
