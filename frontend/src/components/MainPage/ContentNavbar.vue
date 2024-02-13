<template>
  <div class="flex-container">
    <div class="content_navbar_main">
      <div class="content_navbar">
        <div class="content_navbar__icons">
          <svg-icon type="mdi" :path="mdiPlusBoxOutline"></svg-icon>
        </div>
        <div class="content_navbar__icons">
          <svg-icon type="mdi" :path="mdiMinusBoxOutline"></svg-icon>
        </div>
        <div class="content_navbar__icons">
          <svg-icon type="mdi" :path="mdiCheckboxOutline"></svg-icon>
        </div>
      </div>
    </div>
    <div>
      <ag-grid-vue
        style="width: 100%; height: 100%"
        class="ag-theme-alpine"
        :rowHeight="30"
        :columnDefs="columnDefs"
        @grid-ready="onGridReady"
        :defaultColDef="defaultColDef"
        :rowData="getAll"
        :enableFillHandle="true"
        :rowSelection="rowSelection"
        :enableCellChangeFlash="true"
        :undoRedoCellEditing="true"
        :enableRangeSelection="true"
        :undoRedoCellEditingLimit="10"
        :columnTypes="columnTypes"
        @cell-value-changed="onCellValueChanged"
        @selection-changed="onSelectionChanged"
      >
      </ag-grid-vue>
    </div>
  </div>
</template>

<script>
import SvgIcon from "@jamescoyle/vue-icon";
import {
  mdiPlusBoxOutline,
  mdiMinusBoxOutline,
  mdiCheckboxOutline,
} from "@mdi/js";
import { AgGridVue } from "ag-grid-vue3"; // the AG Grid Vue Component
import "ag-grid-community/styles/ag-grid.css"; // Core grid CSS, always needed
import "ag-grid-community/styles/ag-theme-alpine.css"; // Optional theme CSS
export default {
  name: "content-navbar",
  components: {
    SvgIcon,
    AgGridVue,
  },
  methods: {},
  setup() {
    return {
      mdiPlusBoxOutline,
      mdiMinusBoxOutline,
      mdiCheckboxOutline,
    };
  },
};
</script>

<style scoped>
.content_navbar_main {
  border-bottom: 2px solid #f6f8fc;
}
.content_navbar {
  margin-left: 10px;
  display: flex;
  /* justify-content: ; */
  align-items: center;
  height: 45px;
  color: #444746da;
}
.content_navbar__text {
  font-family: system-ui;
  font-weight: 500;
  color: #444746;
}
.content_navbar__icons {
  /* margin-left: 10px; */
  /* padding: 5px; */
  padding-top: auto;
  transition: background-color 0.1s ease;
  border-radius: 8px;
  /* scale: 95%; */
}
.content_navbar__icons:hover {
  background-color: rgba(234, 243, 245, 0.722);
  height: 30px;
  border-radius: 4px;
  /* box-shadow: 2px 1px 2px 2px rgba(0, 0, 0, 0.185); */
}
</style>
