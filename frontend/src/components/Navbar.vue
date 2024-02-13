<template>
  <div class="flex-container">
    <div class="flex-item-logo">
      <img @click="goToMain()" class="logo" src="@/assets/main-app-logo.png" alt="logo" />
    </div>
    <div class="flex-item item-2">
      <div @click="goToMain()" class="home">
        Главная
        <!-- <router-link class="nav-links" :to="/" exact>Home</router-link> -->
      </div>
      <div class="home">
        Пользователь: {{ currentUser }}
        <!-- <router-link class="nav-links" :to="/" exact>Home</router-link> -->
      </div>
      <!-- <div> -->
      <!-- Docs -->
      <!-- <router-link class="nav-links" :to="/" exact>Documentation</router-link> -->
      <!-- </div> -->
      <div>
        <!-- <router-link to="/page" class="header_button">Go to Page</router-link> -->
        <router-link to="/" exact
          ><button class="header_button" @click.prevent="logout">
            Выход
          </button></router-link
        >
      </div>
    </div>
  </div>
</template>

<script>
import { useStore } from "vuex";
import { computed } from "vue";
import { useRouter } from "vue-router";
export default {
  name: "Nav-bar",
  methods: {
    logout() {
      localStorage.clear();
      this.$store.commit("setNotAuth");
      this.$router.push("/");
    },
  },
  setup() {
    const store = useStore();
    const router = useRouter();

    const currentUser = computed(() => store.state.currentUser);

    const goToMain = () => {
      store.commit("setDataToLoad", null);
      router.push("/main");
    };

    return {
      goToMain,
      currentUser,
    };
  },
};
</script>

<style scoped>
.flex-container {
  display: flex;
  align-items: center;
  flex-direction: row;
  justify-content: space-between;
  padding-left: 5px;
  padding-right: 15px;
  height: 40px;
  /* box-shadow: 2px 2px 3px 0px rgba(0, 0, 0, 0.185); */
  font-family: system-ui;
  font-weight: 500;
  /* color: #444746; */
  color: #f9f7f3;
}

.flex-item {
  display: flex;
  flex-direction: row;
}

.logo {
  display: flex;
  align-items: center;
  width: 28px;
  height: auto;
  opacity: 1;
  cursor: pointer;
}

.item-2 {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-left: 15px;
  font-size: 14px;
  gap: 15px;
  cursor: pointer;
}

.nav-links {
  color: rgb(0, 0, 0);
}

.home {
  /* box-shadow: 0 10px 20px rgba(0, 0, 0, 0.9); */
  /* Create a subtle animation for the floating effect */
  transition: box-shadow 0.3s, transform 0.3s;

  /* On hover, increase the floating effect */
  &:hover {
    /* box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2); */
    transform: translateY(-2px);
  }
}

.nav-links:hover {
  color: rgba(0, 136, 169, 0.7);
}

.header_button {
  height: 25px;
  font-size: 13px;
  font-weight: 600;
  color: #f9f7f3;
  width: 60px;
  margin-bottom: 0;
  background-color: #e94f37;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease 0s;
  border-radius: 5px;
}

.header_button:hover {
  box-shadow: 2px 1px 2px 2px rgba(0, 0, 0, 0.185);
  /* background-color: rgba(25, 138, 167, 0.824); */
}
</style>
