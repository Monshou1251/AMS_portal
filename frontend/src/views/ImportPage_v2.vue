<template>
  <div class="main-body">
    <div class="grid-container__main">
      <header>
        <nav>
          <Navbar />
        </nav>
      </header>

      <div class="content">
        <FileUploader_v2 />
      </div>

      <div>
        <SidebarRight />
      </div>
    </div>
  </div>
</template>
<script>
import Navbar from "@/components/Navbar.vue";
import SidebarRight from "@/components/Sidebars/SidebarRight.vue";
import FileUploader_v2 from "@/components/FileUploader/FileUploader_v2.vue";
// import { ref } from "vue";

export default {
  components: {
    Navbar,
    SidebarRight,
    FileUploader_v2,
  },
  setup() {
    return {};
  },
};
</script>
<style scoped>
.main-body {
  font-family: system-ui;
  font-weight: 400;
  color: #444746;
  background-color: #0530488a;
  color: #444746;
}

.grid-container__main {
  display: grid;
  grid-template-rows: auto 1fr auto; 
  grid-template-columns: 1fr auto; 
  grid-template-areas:
    "header header"
    "content thin-sidebar" ;
  height: 100vh;
  min-height: max-content;
  width: 100%;
  overflow: auto;
}
header {
  grid-area: header;
}

.content {
  flex: 1;
  display: flex;
  flex-direction: column;
  grid-area: content;
  background-color: #ffffffc9;
  border-radius: 10px;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
  margin-left: 10px;
}

.thin-sidebar {
  grid-area: thin-sidebar;
}

header {
  grid-area: header;
}
</style>
