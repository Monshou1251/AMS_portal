import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import axios from "axios";
import store from "./store";

axios.defaults.baseURL = "http://127.0.0.1:8000";
// axios.defaults.headers.common["Authorization"] =
//   "Bearer " + localStorage.getItem("access");

axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("access");
    const username = store.state.currentUser;
    // console.log('im in main, username: ', username)
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
      // console.log('In main, token exists')
    }

    if (username) {
      config.headers["X-Username"] = username;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

createApp(App).use(store).use(router, axios).mount("#app");
