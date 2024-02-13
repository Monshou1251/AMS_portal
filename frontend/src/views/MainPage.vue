<template>
  <!-- <div class="main-body"> -->
    <div class="grid-container__main">
      <header>
        <nav>
          <Navbar></Navbar>
        </nav>
      </header>
      <div class="sideBar__left">
        <MainTree></MainTree>
      </div>

      <main class="content">
        <component :is="currentComponent"></component>
      </main>

      <div>
        <SidebarRight></SidebarRight>
      </div>
      <footer>
        <FooterComp></FooterComp>
      </footer>
    </div>
  <!-- </div> -->
</template>
<script>
import Navbar from "@/components/Navbar.vue";
import SidebarRight from "@/components/Sidebars/SidebarRight.vue";
import MainTree from "@/components/Sidebars/RecursiveComp/MainTree.vue";
import ContentMain from "@/components/MainPage/ContentMain.vue";
import StatisticPage from "@/components/MainPage/StatisticPage.vue";
import FileUploader from "@/components/FileUploader/FileUploader_v2.vue";
import CancelTransfer from "@/components/CancelTransfer/CancelTransfer";
import CancelTransferAMS from "@/components/CancelTransfer/CancelTransferAMS";
import GenerateTransfer from "@/components/CancelTransfer/GenerateTransfer";
import FooterComp from "@/components/FooterComp/FooterComp";
// import { ref } from "vue";

export default {
  components: {
    Navbar,
    ContentMain,
    MainTree,
    SidebarRight,
    StatisticPage,
    FileUploader,
    CancelTransfer,
    FooterComp,
    CancelTransferAMS,
    GenerateTransfer,
  },
  computed: {
    currentComponent() {
      if (this.$store.state.dataToLoad === null) {
        return "StatisticPage";
      } else if (this.$store.state.dataToLoad == "FileUploader") {
        return "FileUploader"
      } else if (this.$store.state.dataToLoad == "CancelTransfer") {
        return "CancelTransfer"
      } else if (this.$store.state.dataToLoad == "GenerateTransfer") {
        return "GenerateTransfer"
      } else if (this.$store.state.dataToLoad == "CancelTransferAMS") {
        return "CancelTransferAMS"
      } else {
        return "ContentMain";
      }
    },
  },
  setup() {
    // const currentComponent = ref("StatisticPage");
    return {
      // currentComponent,
    };
  },
};
</script>
<style scoped>
.main-body {
  
}

.grid-container__main {
  font-family: system-ui;
  font-weight: 400;
  color: #444746;
  /* background-image: url("../assets/bg1.png");
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center; */
  background-color: #0530488a;
  display: grid;
  grid-template-rows: auto 1fr 30px;
  grid-template-columns: auto 1fr auto;
  grid-template-areas:
    "header header header"
    "sidebar content thin-sidebar"
    "footer footer footer";
  min-height: 100vh;
  width: auto;
  overflow: hidden;
  box-sizing: border-box;
  overflow-x: auto;
}
header {
  grid-area: header;
}

.sideBar__left {
  background-color: #ffffffc9;
  color: #444746;
  /* background-color: #444746;
  color: #fff; */
  border-radius: 10px;
  /* height: 100%; */
  margin-right: 5px;
  margin-left: 5px;
  width: 350px;
  overflow:auto;
}

.content {
  flex: 1;
  display: flex;
  flex-direction: column;
  grid-area: content;
  background-color: #ffffffc9;
  border-radius: 10px;
  /* box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5); */
}

.thin-sidebar {
  grid-area: thin-sidebar;
  /* padding: 10px; */
}

footer {
  grid-area: footer;
}
</style>
