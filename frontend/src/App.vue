<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "App",
  components: {},
  beforeCreate() {
    this.$store.commit("initializeStore");
    // const access = this.$store.state.access;
    const access = localStorage.getItem("access")

    if (access) {
      axios.defaults.headers.common["Authorization"] = `Bearer ${access}`;
    } else {
      axios.defaults.headers.common["Authorization"] = "";
    }
  },
  mounted() {
    const refreshInterval = 600000
    if (localStorage.getItem("refresh")) {
      setInterval(() => {
        this.getAccess();
      }, refreshInterval);
    }
    this.getAccess()
  },
  methods: {
    clearTokens() {
      localStorage.removeItem("access");
      localStorage.removeItem("refresh");
      this.$router.push("/");
    },
    getAccess() {
      const accessData = {
        refresh: localStorage.getItem("refresh"),
      };

      axios
        .post("api/token/refresh/", accessData)
        .then((response) => {
          const access = response.data.access;
          localStorage.setItem("access", access);
          this.$store.commit("setAccess", access);
          axios.defaults.headers.common["Authorization"] = `Bearer ${access}`;
        })
        .catch((error) => {
          if (error.response && error.response.status === 401) {
            this.clearTokens();
          }
          console.log(error);
        });
    },
  },
};
</script>

<style>
#app {
  font-family: var(--font-family);
  font-family: system-ui;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  /* height: 100%; */
  /* min-height: fit-content; */
  /* min-height: 100%; */
}

html,
body {
  margin: 0;
  /* height: 100%; */
  /* display: grid; */
}
</style>
