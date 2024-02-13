<template>
  <div>
    <div class="container">
      <div class="row justify-content-md-center">
        <div class="col-md-5 p-3 login justify-content-md-center">
          <img
            class="img"
            src="@/assets/main-app-logo.png"
            alt="Description of the image"
          />
          <p class="title">Портaл AMS</p>
          <!-- <h1 class="h3 mb-3 font-weight-normal text-center">Войдите</h1> -->
          <!-- <mcv-validation-errors
            v-if="validationErrors"
            :validation-errors="validationErrors"
          /> -->
          <!-- <mcv-validation-errors /> -->

          <form class="inputDiv" v-on:submit.prevent="submitForm">
            <div v-show="validationErrors" class="alert alert-danger">
              {{ validationErrors }}
            </div>
            <div class="form-group mb-2">
              <input
                type="text"
                name="username"
                v-model="username"
                class="form-control"
                placeholder="Имя"
              />
            </div>
            <div class="form-group mb-2">
              <input
                type="password"
                name="password"
                v-model="password"
                class="form-control"
                placeholder="Пароль"
              />
            </div>
            <div  class="button-container">
              <button v-if="!isLogging" type="submit" id="loginbutton">Войти</button>
              <div v-else class="spinner" ></div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "login-page",
  data() {
    return {
      username: "",
      password: "",
      validationErrors: "",
      isLogging: false,
    };
  },
  methods: {
    async submitForm() {
      this.isLogging = true
      axios.defaults.headers.common["Authorization"] = "";
      localStorage.removeItem("access");

      const formData = {
        username: this.username,
        password: this.password,
      };

      if (!this.username || !this.password) {
        this.validationErrors = "Please input your credentials";
        this.isLogging = false
        return;
      }

      try {
        console.log('Im trying to send the login request')
        const response = await axios.post("/api/token/", formData);
        const username = formData.username.split('@')[0]
        console.log("username: ", username)
        this.$store.commit("setCurrentUser", username);
        console.log('I sent the login request')

        try {
          const saveCredentials = await axios.post("set_exasol_credentials/", formData);
          console.log(saveCredentials.data)
        } catch (error) {
          console.warn(error)
        } finally {
          this.isLogging = false
        }
        
        

        const access = response.data.access;
        const refresh = response.data.refresh;

        this.$store.commit("setAccess", access);
        this.$store.commit("setRefresh", refresh);

        // axios.defaults.headers.common["Authorization"] = `Bearer ${access}`;
        localStorage.setItem("access", access);
        localStorage.setItem("refresh", refresh);

        // await this.$store.dispatch("fetchUserPermissions"); 

        this.$store.commit("setIsAuth");
        this.$store.state.isAuthorized = true;

        // console.log(this.$store.state.userPermissions); 
        console.log("I'm in login file, before pushing to main")
        this.$router.push("/main");
      } catch (error) {
        console.log(error);
        this.$store.commit("setNotAuth");
        this.validationErrors = "Неверное имя пользователя или пароль";
        this.isLogging = false
      } finally {
        this.isLogging = false
      }
    },
  },
};
</script>

<style scoped>

body {
  background-color: #ffffff;
}
.img {
  position: relative;
  display: block;
  top: 10px;
  left: 10px;
  width: 8%;
  height: auto;
  opacity: 0.8;
}
.container {
  display: flex;
  justify-content: center;
  font-family: system-ui;
  font-weight: 400;
}
.login {
  background-color: #2595be22;
  margin-top: 20%;
  border-radius: 10px;
  width: 400px;
  height: 300px;
  color: #444746;
}
.inputDiv {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 30px;
}
.form-control {
  margin-top: 2%;
  padding: 8px 20px;
  font-size: 14px;
  border-radius: 5px;
  border-width: 2px;
  border-color: #154c7952;

}

.form-control:focus {
  outline: none;
  border: 2px solid #154c798e;
  box-shadow: 0 0 5px #2595be22;
}

#loginbutton {
  height: 40px;
  color: hwb(0 100% 0%);
  width: 100px;
  margin-top: 30px;
  display: inline-block;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease 0s;
  font-size: 14px;
  border-radius: 5px;
  font-weight: 600;
  box-shadow: 1px 1px 3px #aaaaaa;
  opacity: 0.8;
  background-color: #db0025eb;
}

#loginbutton:hover {
  background-color: #db0025ba;
}

.spinner {
  border: 3px solid hwb(0 100% 0%);
  border-top: 3px solid #db0025ba;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  animation: spin 1s linear infinite;
  margin: auto;
  margin-top: 30px;
}

@keyframes spin {
  0% { transform: rotate(0deg)}
  100% { transform: rotate(360deg);}
}

.title {
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: system-ui;
  font-weight: 700;
  font-size: large;
  color: #154c79ac;
}

</style>
