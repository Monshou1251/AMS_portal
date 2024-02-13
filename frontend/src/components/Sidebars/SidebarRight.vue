<template>
  <!-- <div>button</div> -->
  <div class="sidebar_content">
    <div class="links">
      <div class="line_class_rsb custom-router-link">
        <!-- <router-link
          :to="{ name: 'import' }"
          class="custom-router-link"
          :class="{ 'active-effect': isActive }"
        >
      </router-link> -->
      <svg-icon type="mdi" :path="mdiCog" class="icons_rsb"></svg-icon>
      </div>

      <div class="line_class_rsb custom-router-link">
        <!-- <router-link
          :to="{ name: 'import' }"
          class="custom-router-link"
          :class="{ 'active-effect': isActive }"
          @click="handleClick"
        >
      </router-link> -->
      <svg-icon
        type="mdi"
        :path="mdiApplicationSettings"
        class="icons_rsb"
      ></svg-icon>
      </div>

      <div class="line_class_rsb custom-router-link">
        <!-- <router-link
          :to="{ name: 'import_v2' }"
          class="custom-router-link"
          :class="{ 'active-effect': isActive }"
        >
      </router-link> -->
      <svg-icon
        type="mdi"
        :path="mdiInformationBox"
        class="icons_rsb"
      ></svg-icon>
      </div>

      <div class="line_class_rsb custom-router-link">
        <!-- <router-link
          :to="{ name: 'airflow' }"
          class="custom-router-link"
          :class="{ 'active-effect': isActive }"
        >
        </router-link> -->
      <svg-icon
        type="mdi"
        :path="mdiFileCodeOutline"
        class="icons_rsb"
      ></svg-icon>
      </div>
      <!-- <div class="line_class_rsb">
        <router-link
          :to="{ name: 'transfer' }"
          class="custom-router-link"
          :class="{ 'active-effect': isActive }"
        >
          <svg-icon
            type="mdi"
            :path="mdiFileCancelOutline"
            class="icons_rsb"
          ></svg-icon>
        </router-link>
      </div> -->
    </div>
  </div>
</template>

<script>
import { ref } from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
// import { mdiAccount } from "@mdi/js";
import {
  mdiDatabaseExportOutline,
  mdiCog,
  mdiFileCodeOutline,
  mdiSourcePull,
  mdiCalendarCollapseHorizontalOutline,
  mdiApplicationSettings,
  mdiInformationBox,
  mdiFileCancelOutline,
} from "@mdi/js";
export default {
  name: "Side-bar",
  components: {
    SvgIcon,
  },
  setup() {
    const isActive = ref(false);

    const handleClick = () => {
      isActive.value = true;

      setTimeout(() => {
        isActive.value = false;
      }, 50);
    };

    return {
      path: mdiDatabaseExportOutline,
      mdiFileCodeOutline,
      mdiSourcePull,
      mdiCalendarCollapseHorizontalOutline,
      mdiCog,
      mdiApplicationSettings,
      mdiInformationBox,
      mdiFileCancelOutline,
      handleClick,
      isActive,
    };
  },
};
</script>

<style>
.sidebar_content {
  /* Apply overflow: hidden to prevent scrollbars */
  overflow: hidden;
}

.custom-router-link {
  color: inherit;
  /* color: #f9f7f3; */
  text-decoration: none;
  display: inline-block;
  transition: transform 0.2s ease;

  &:hover {
    transform: scale(1.1);
    color: #f9f7f3;
    /* color: #474747; */
  }
  &.active-effect {
    transform: scale(1);
  }
}

.custom-icon {
  /* color: inherit; */

  &.active-effect {
    transform: scale(1.1);
  }
}

.icon-container {
  width: 24px;
  height: 24px;
  transition: transform 0.3s ease;
}

.links {
  margin-top: 20px;
  /* margin-left: 10px; */
  list-style: none;
  text-decoration: none;
  font-family: system-ui;
  font-weight: 500;
  color: #444746;
}

.line_class_rsb {
  display: flex;
  /* justify-content: center; */
  margin-left: 0;
  align-items: center;
  margin-bottom: 10px;
  border-radius: 10px 0px 0px 10px;
  transition: background-color 0s;
  height: 30px;
}

.text_class {
  display: flex;
  margin-left: 8px;
  align-items: center;
}

.icons_rsb {
  display: flex;
  margin-left: 10px;
  margin-right: 10px;
  cursor: pointer;
}
</style>
