<template>
  <div class="main-body">
    <div class="grid-container">
      <header>
        <nav>
          <Navbar></Navbar>
        </nav>
      </header>
      <div class="sideBar__left">
        <MainTree></MainTree>
      </div>

      <div class="content">
        <!-- <ContentMain></ContentMain> -->
      </div>

      <div>
        <SidebarRight></SidebarRight>
      </div>
    </div>
  </div>
</template>
<script>
// import { ref, watch } from "vue";
import Navbar from "@/components/Navbar.vue";
// import SidebarLeft from "@/components/SidebarLeft.vue";
import SidebarRight from "@/components/Sidebars/SidebarRight.vue";
// import SidebarTree from "@/components/SidebarTree.vue";
// import ContentMain from "@/components/MainPage/ContentMain.vue";
// import TreeBrowser from "@/components/Sidebars/TreeBrowser.vue";
import MainTree from "@/components/Sidebars/RecursiveComp/MainTree.vue";

export default {
  components: {
    Navbar,
    SidebarRight,
    // ContentMain,
    MainTree,
  },
  setup() {},
};
</script>
<style>
/* main {
  height: 100%;
} */

/* .sideBar__left {
  background-color: #fff;
  border-radius: 10px;
  height: 100%;
  margin-right: 10px;
} */
/* .grid-container {
  display: grid;
  grid-template-rows: auto 1fr;
  grid-template-columns: 300px 1fr auto;
  grid-template-areas:
    "header header header"
    "sidebar content thin-sidebar";
  height: 100%;
  width: 100%;
} */

/* nav ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
} */
/* 
nav li {
  display: inline;
  margin-right: 10px;
} */

/* .sidebar {
  grid-area: sidebar;
  padding: 10px;
  list-style: none;
} */

/* .content {
  grid-area: content;
  background-color: #fff;
  border-radius: 10px;
} */

/* .thin-sidebar {
  grid-area: thin-sidebar;
} */
</style>
