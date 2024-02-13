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
          <h1 class="h3 mb-3 font-weight-normal text-center">
            Да это же успех
          </h1>
          <!-- <mcv-validation-errors
              v-if="validationErrors"
              :validation-errors="validationErrors"
            /> -->
          <!-- <mcv-validation-errors /> -->

          <button @click.prevent="logout" id="loginbutton">Выйти</button>

          <!-- <form class="inputDiv" v-on:submit.prevent="submitForm">
            <button type="submit" id="loginbutton">Радоваться</button>
          </form> -->
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import {mapState} from 'vuex'
//   import axios from "axios";

export default {
  name: "main-page",
  methods: {
    logout() {
      localStorage.removeItem("access");
      localStorage.removeItem("refresh");
      this.$store.commit("setNotAuth");
      this.$router.push("/");
    },
  },
  computed: {},
  components: {},
  data() {
    return {};
  },
};
</script>

<style lang="scss"></style>
