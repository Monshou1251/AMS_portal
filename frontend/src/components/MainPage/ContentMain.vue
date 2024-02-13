<template>
  <div class="flex-container">
    <div class="content_navbar_main">
      <div class="content_navbar">
        <!-- Left Icons -->
        <div class="left-icons">
          <div
            :class="{
              content_navbar__icons: true,
              disabled: isButtonsDisabled,
            }"
            @click="handleAdd"
          >
            <svg-icon type="mdi" :path="mdiPlusBoxOutline"></svg-icon>
          </div>
          <div
            :class="{
              content_navbar__icons: true,
              disabled: isButtonsDisabled,
            }"
            @click="deleteSelectedRows"
          >
            <svg-icon type="mdi" :path="mdiMinusBoxOutline"></svg-icon>
          </div>
          <div
            :class="{
              content_navbar__icons: true,
              disabled: isButtonsDisabled,
            }"
            @click="onSubmit"
          >
            <svg-icon type="mdi" :path="mdiCheckboxOutline"></svg-icon>
          </div>
        </div>
        <div class="content_navbar__info">
          <span>Table name: </span>
          <span class="dataToLoad">{{ dataToLoad }}</span>
        </div>
        <!-- Right Icons -->
        <div class="right-icons">
          <div class="content_navbar__pag_icons">
            <svg-icon
              type="mdi"
              :path="mdiChevronLeft"
              @click="loadPreviousPage"
            ></svg-icon>
          </div>
          <div>{{ currentCount }}</div>
          <div class="content_navbar__pag_icons">
            <svg-icon
              type="mdi"
              :path="mdiChevronRight"
              @click="loadNextPage"
            ></svg-icon>
          </div>
        </div>
      </div>
    </div>
    <div v-if="isLoading" class="spinner-container">
      <div class="spinner"></div>
    </div>
    <div v-else>
      <ag-grid-vue
        style="width: 100%; height: 100%"
        class="ag-theme-alpine"
        :rowHeight="30"
        :sizeColumnsToFit="true"
        :columnDefs="columnDefs"
        :columnTypes="columnTypes"
        @grid-ready="onGridReady"
        :defaultColDef="defaultColDef"
        :rowData="getAll"
        :rowSelection="rowSelection"
        :enableCellChangeFlash="true"
        :undoRedoCellEditing="true"
        :undoRedoCellEditingLimit="10"
        :pagination="false"
        :paginationAutoPageSize="false"
        :domLayout="domLayout"
        :suppressBrowserResizeObserver="true"
        :gridOptions="gridOptions"
        :locale-text="computedLocaleText"
        @cell-clicked="onCellClicked"
      >
      </ag-grid-vue>
    </div>
  </div>
</template>

<script>
/* eslint-disable */
import {
  ref,
  onMounted,
  computed,
  watch,
  watchEffect,
  h,
  onUnmounted,
  onBeforeUnmount,
} from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
import {
  mdiPlusBoxOutline,
  mdiMinusBoxOutline,
  mdiCheckboxOutline,
  mdiChevronLeft,
  mdiChevronRight,
} from "@mdi/js";
import { AgGridVue } from "ag-grid-vue3";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-alpine.css";
import axios from "axios";
import router from "@/router";
import store from "@/store";
import isEqual from "lodash/isEqual";
import CustomFilter from "./CustomFilter.vue";
import CustomHeader from "./CustomHeader.vue";
export default {
  name: "content-navbar",
  components: {
    SvgIcon,
    AgGridVue,
  },

  setup() {
    const isLoading = ref(false);
    const getAll = ref([]);
    const dataBackup = ref([]);
    const columnDefs = ref(null);
    const gridApi = ref(null);
    const gridColumnApi = ref();
    const errorCondition = ref(false);

    const sortState = computed(() => {
      return store.state.sorting;
    });

    const computedLocaleText = computed(() => {
      if (errorCondition.value) {
        return {
          noRowsToShow: `Таблица ${dataToLoad.value} отсутствует в базе данных`,
        };
      } else {
        return { noRowsToShow: "Нет данных для отображения" };
      }
    });

    const autoSizeAll = (skipHeader) => {
      const allColumnIds = [];
      gridColumnApi.value.getColumns().forEach((column) => {
        allColumnIds.push(column.getId());
      });
      gridColumnApi.value.autoSizeColumns(allColumnIds, skipHeader);
    };

    const gridOptions = ref({
      onCellValueChanged: ({ oldValue, newValue, node, source }) => {
        const oldRow = dataBackup.value.find((row) => row[pk] === oldValue);
      },
      frameworkComponents: {
        CustomFilterComponent: CustomFilter,
        CustomHeader: CustomHeader,
      },
    });

    const onGridReady = (params) => {
      gridApi.value = params.api;
      gridColumnApi.value = params.columnApi;
      // gridOptions.value = params.api
    };
    let column_type = {};
    const deselectRows = () => {
      gridApi.value.deselectAll();
    };
    const domLayout = ref("autoHeight");

    const testFilter = () => {
      console.log("BUTTON");
      gridApi.value.setFilterModel({
        integration_code_sid: {
          filterType: "text",
          type: "equals",
          filter: "1",
        },
      });
    };

    const checkboxRenderer = (params) => {
      if (
        isBooleanColumn(params.colDef.field) &&
        typeof params.value === "boolean"
      ) {
        const checked = params.value ? "checked" : "";
        const isEditable = !store.state.tables.includes(dataToLoad.value);
        return `
      <div style="display: flex; justify-content: center; align-items: center; height: 100%;">
        <input type="checkbox" ${checked} @click.stop="onCellClicked(params)" ${
          isEditable ? "" : "disabled"
        }>
      </div>`;
      }
      return params.value;
    };

    const selectedDate = ref(null);

    const onDateChange = (event, id) => {
      const selectedDate = event.target.value;
      console.log("Selected date:", selectedDate);
      console.log("data data:", event.data);

      const rowIndex = getAll.value.findIndex((item) => item.id === id);
      console.log("Im in onDateChange", rowIndex);

      if (rowIndex !== -1) {
        getAll.value[rowIndex]["your_date_field"] = selectedDate;
      }
    };

    const dateCellRenderer = (params) => {
      const columnType = column_type[params.colDef.field];
      if (columnType === "DATE") {
        const dateValue = params.value
          ? new Date(params.value).toISOString().slice(0, 10)
          : null;

        const dateStyle = `
      display: inline-block;
      border: none;
      outline: none;
      background-color: transparent;
      font-family: system-ui;
      font-size: 14px;
      padding-right: 1rem;
    `;

        const inputElement = document.createElement("input");
        inputElement.setAttribute("style", dateStyle);
        inputElement.setAttribute("type", "date");
        inputElement.setAttribute("value", dateValue);

        // Add the event listener to the input element
        inputElement.addEventListener("change", (event) => {
          const columnName = params.colDef.field; // Get the name of the column
          const datePk = params.data[pk];
          console.log("Im in EventListener:", datePk);
          console.log("Im in EventListener pk:", pk);

          // Find the index of the row in the getAll data array that matches the provided id
          const rowIndex = getAll.value.findIndex(
            (item) => item[pk] === datePk
          );

          // If the row is found, update the value for the specified field
          if (rowIndex !== -1) {
            getAll.value[rowIndex][columnName] = event.target.value;
          }
        });

        return inputElement;
      }

      return params.value;
    };

    // Function to check if a column contains boolean values
    const isBooleanColumn = (columnName) => {
      // Check if the column type is "BOOLEAN" in the columnTypes variable
      const columnType = column_type[columnName];
      if (columnType === "BOOLEAN") {
        return true;
      }

      const columnData = getAll.value.map((row) => row[columnName]);

      // Check if all values in the column are boolean (true/false) or numeric (1/0)
      const isBoolean = columnData.every(
        (value) =>
          value === true || value === false || value === 1 || value === 0
      );

      return isBoolean;
    };

    // const checkboxRendererParams = ref({ renderer: checkboxRenderer });

    const columnTypes = {
      idColumn: {
        editable: false,
        maxWidth: 70,
        resizable: false,
        headerName: "",
      },
      checkBox: {
        editable: false,
        // maxWidth: 70,
        resizable: false,
        headerName: "",
      },
      nonEditable: { editable: false },
    };

    // Function to get the data from backend and to handle pagination
    let page = ref(1);
    const pageSize = 20;
    let totalCount = ref(0);
    const currentCount = computed(() => {
      const startOfPage = (page.value - 1) * pageSize + 1;
      let endOfPage = page.value * pageSize;
      endOfPage = endOfPage > totalCount.value ? totalCount.value : endOfPage;

      if (totalCount.value === 0) {
        return 0;
      }
      let x = `${startOfPage} - ${endOfPage} из ${totalCount.value}`;

      if (startOfPage > endOfPage) {
        x = `${endOfPage} из ${totalCount.value}`;
      }

      if (errorCondition.value == true) {
        x = `0`;
      }

      return x;
    });

    // this property is used to set what table from DB will be loaded
    const dataToLoad = computed(() => store.state.dataToLoad);

    // Disable all buttons that are used to manipulate with data (for
    // only READ tables)
    const isButtonsDisabled = computed(() =>
      store.state.tables.includes(dataToLoad.value)
    );

    let pk = null;
    const appliedFilters = computed(() => {
      return store.state.appliedFilters;
    });
    const appliedSorting = computed(() => store.state.sorting);
    // const appliedSorting = store.state.sorting

    let cancelSource = axios.CancelToken.source();

    // Thats the main function to fetch the data from backend.
    // Additionally inside it ColumnDefs are defined.
    const getData = async () => {
      try {
        // Cancel the previous request if it exists
        cancelSource.cancel("Request cancelled");

        // Create a new CancelToken source for the current request
        cancelSource = axios.CancelToken.source();

        // Update the cancel token in the request configuration
        const config = {
          cancelToken: cancelSource.token,
        };
        isLoading.value = true;
        let response;
        let sortingParams = "";

        const filterParams = JSON.stringify(appliedFilters.value);
        const encodedFilterParams = encodeURIComponent(filterParams);

        if (appliedSorting.value.columnName && appliedSorting.value.direction) {
          sortingParams = `sort_by=${encodeURIComponent(
            appliedSorting.value.columnName
          )}&sort_order=${encodeURIComponent(appliedSorting.value.direction)}`;
          // console.log(sortParam)
          // sortingParams = encodeURIComponent(sortParam)
        }

        if (dataToLoad.value !== "ams_cfg.user_access") {
          response = await axios.get(
            `/exasol-data?page=${page.value}&page_size=${pageSize}&table=${dataToLoad.value}&filters=${filterParams}&${sortingParams}`,
            config
          );
        } else {
          response = await axios.get(
            `/user_access_view?page=${page.value}&page_size=${pageSize}&table=${dataToLoad.value}`,
            config
          );
        }

        totalCount.value = response.data.total_count;
        let config_data = response.data.config_data;
        column_type = response.data.column_types;

        if (Array.isArray(response.data.primary_keys)) {
          pk = response.data.primary_keys[0];
        } else {
          pk = response.data.primary_keys;
        }

        console.log("response.data.columns");
        console.log(response.data.columns);

        const columnHeaders = response.data.columns;
        const amsIntegrCodeIndex = columnHeaders.indexOf("ams_integr_code");

        if (amsIntegrCodeIndex !== -1) {
          columnHeaders.splice(amsIntegrCodeIndex, 1);
          columnHeaders.unshift("ams_integr_code");
          console.log("columnHeaders");
          console.log(columnHeaders);
        }

        columnDefs.value = columnHeaders.map((key) => {
          const columnType = response.data.column_types[key];
          const isBool = columnType === "BOOLEAN";
          const isDate = columnType === "DATE";
          const isEditable = store.state.tables.includes(dataToLoad.value);

          const table = dataToLoad.value.toUpperCase();
          let alias = key;

          if (Array.isArray(config_data[table])) {
            const obj = config_data[table].find(
              (item) => item[key.toUpperCase()]
            );
            if (obj) {
              alias = obj[key.toUpperCase()];
            }
          }

          // Check if it's user_access table and the column is USER_ID or SHEET_ID
          const isUserAccessTable = dataToLoad.value === "user_access";
          const isNonEditableColumn = key === "USER_ID" || key === "SHEET_ID";

          const cellStyle = (params) => {
            if (params.value === false || params.value === true) {
              return {
                "background-color": "rgba(128, 128, 128, 0.060)",
                "box-shadow": "1px 0px 0px rgba(128, 128, 128, 0.016)",
                color: "#444746da",
                "font-size": "14px",
                editable: false,
              };
            }

            if (isUserAccessTable && isNonEditableColumn) {
              print("im in user_access C");
              return {
                "background-color": "rgba(128, 128, 128, 0.060)",
                "box-shadow": "1px 0px 0px rgba(128, 128, 128, 0.016)",
                color: "#444746da",
                "font-size": "14px",
                editable: false,
              };
            }

            return null;
          };

          const backgroundColor = key === "ams_integr_code" ? "green" : null;

          return {
            headerName: alias.toUpperCase(),
            field: key,
            headerComponent: "CustomHeader",
            filter: "CustomFilterComponent",

            // autoHeaderText:true,
            // autoHeaderHeight: true,
            // autoSizeAll: true,
            // supressSizeToFit: true,
            // sizeColumnsToFit: true,
            type: isBool
              ? "checkBox"
              : determineType(key, dataToLoad.value, pk),
            cellRenderer: isBool
              ? checkboxRenderer
              : isDate && !isEditable && key !== pk
              ? dateCellRenderer
              : null,
            cellStyle,
            "background-color": backgroundColor,
            minWidth: Math.max(alias.length * 15, 100),
          };

          function determineType(columnName, table, columnType) {
            if (
              (table === "test_schema.user_access" &&
                (columnName === "user_id" || columnName === "sheet_id")) ||
              columnType === columnName
            ) {
              return "nonEditable";
            } else {
              return isEditable ? "nonEditable" : null;
            }
          }
        });

        getAll.value = response.data.data;
        dataBackup.value = response.data.data;

        // In here I add an index column the data, and
        // set the values of the rows based on page and pageSize
        let indexAdd = [];
        let indexAddBack = [];
        indexAdd = getAll.value.map((item, index) => ({
          index: ++index + (page.value - 1) * `${pageSize}`,
          ...item,
        }));
        indexAddBack = getAll.value.map((item, index) => ({
          index: ++index + (page.value - 1) * `${pageSize}`,
          ...item,
        }));

        getAll.value = indexAdd;
        dataBackup.value = indexAddBack;

        let getKeys = Object.keys(indexAdd[0]);
        for (const i of getKeys) {
          if (i == "index") {
            let ff = {
              field: i,
              type: "idColumn",
              cellStyle: {
                "background-color": "rgba(128, 128, 128, 0.060)",
                "box-shadow": "1px 0px 0px rgba(128, 128, 128, 0.016)",
                color: "#444746da",
                "font-size": "14px",
              },
            };
            columnDefs.value.unshift(ff);
          }
        }

        isLoading.value = false;
      } catch (error) {
        console.error(error);
        isLoading.value = false;

        if (error.response && error.response.status === 401) {
          const accessToken = localStorage.getItem("access");
          console.log("I caught error 404");

          if (accessToken) {
            console.log("Im in if accessToken");
            axios.defaults.headers.common["Authorization"] =
              "Bearer " + accessToken;
            await getData();
          } else {
            router.push("/");
          }
        }

        if (error.response && error.response.status === 500) {
          getAll.value = [];
          errorCondition.value = true;
          columnDefs.value = [];
        }
      }
    };

    watch(
      appliedFilters.value,
      async (newFilters) => {
        await getData();
      },
      { immediate: true }
    );

    watch(store.state.sorting, async (oldSorting) => {
      // if (newSorting.columName && newSorting.direction) {
      //   console.log("store.state.sorting")
      // }
      await getData();
    });

    // That watcher function is used to updated the Content component everytime
    // when different get request is generated
    watch(
      () => store.state.dataToLoad,
      async (newValue, oldValue) => {
        dataToDeleteId.length = 0;
        dataBackup.length = 0;
        page.value = 1;
        store.dispatch("clearSorting");
        store.dispatch("clearFilter");
        // console.log(store.state.)
        await getData();
      }
    );

    const loadNextPage = async () => {
      const maxPage = Math.ceil(totalCount.value / pageSize);

      if (page.value < maxPage) {
        page.value++;
        await getData();
      }
    };

    const loadPreviousPage = async () => {
      if (page.value > 1) {
        page.value--;
        await getData();
      }
    };

    onMounted(getData);

    let rowSelection = "multiple";

    const defaultColDef = {
      sortable: false,
      filter: false,
      filterParams: {
        maxNumConditions: 1,
        buttons: ["reset", "apply"],
        closeOnApply: true,
      },
      flex: 1,
      resizable: true,
      editable: true,
      // initialWidth: 200,
      // wrapHeaderText: true,
      // autoHeaderHeight: true,
      // autoSizeAll: true,
      // supressSizeToFit: true,
      // sizeColumnsToFit: true,
      minWidth: 200,
    };

    const handleAdd = (append) => {
      const newStore = getAll.value.slice();
      const newData = [];
      for (let i in columnDefs.value) {
        newData.push(columnDefs.value[i]["field"]);
      }
      const newDataNull = {};
      for (let z in newData) {
        if (newData[z] === "index") {
          newData[z] = null;
        } else {
          const fieldName = newData[z];
          const columnType = column_type[fieldName];
          if (columnType === "BOOLEAN") {
            newDataNull[newData[z]] = false;
          } else if (columnType === "DATE") {
            const currentDate = new Date().toISOString().slice(0, 10);
            newDataNull[newData[z]] = currentDate;
          } else {
            newDataNull[newData[z]] = "[null]";
          }
        }
      }
      if (append) {
        newStore.unshift(newDataNull);
        getAll.value = newStore;
      } else {
        getAll.value.splice(0, 0, newDataNull);
      }
    };

    // That function delete selected row (or rows) on client side only
    const dataToDeleteId = [];
    const deleteSelectedRows = () => {
      const selectedRows = gridApi.value.getSelectedRows();
      const selectedIds = selectedRows.map((row) => row[pk]);
      // console.log("selectedIds: ", selectedIds);
      for (const data of selectedIds) {
        dataToDeleteId.push(data);
      }
      console.log("dataToDeleteId: ", dataToDeleteId);
      // Filter the original data array to exclude the selected rows
      getAll.value = getAll.value.filter(
        (row) => !selectedIds.includes(row[pk])
      );
    };

    // That function is used to save all changes in DB
    // It separetly check fo deleted, updated and added data
    const onSubmit = async () => {
      const deletedData = [];
      const changedData = [];
      const newData = [];

      if (dataToDeleteId.length > 0) {
        console.log("There is some data to delete: ", dataToDeleteId);
        try {
          await axios.delete("/exasol_data_delete", {
            data: {
              dataIds: dataToDeleteId,
              tableName: dataToLoad.value,
            },
            headers: { Authorization: "Bearer " + localStorage.access },
          });

          dataToDeleteId.length = 0;
          console.log("Data was deleted successfuly");
        } catch (error) {
          console.error("Delete operation failed:", error);
        }
      }

      // Check for changed rows
      for (const newRow of getAll.value) {
        if (newRow[pk]) {
          const oldRow = dataBackup.value.find((row) => row[pk] === newRow[pk]);
          if (!isEqual(oldRow, newRow) && oldRow !== undefined) {
            const { index, ...updatedRow } = newRow;
            changedData.push(updatedRow);
          }
        }
      }

      if (changedData.length > 0) {
        console.log("There are some data changes: ", changedData);

        if (dataToLoad.value == "ams_cfg.user_access") {
          console.log("YESSS, I will send and different PUT request soon");
          try {
            await axios.put(
              "user_access_put_view",
              {
                data: changedData,
                tableName: dataToLoad.value,
              },
              {
                headers: { Authorization: "Bearer " + localStorage.access },
              }
            );
            console.log("Data was updated successfully");
          } catch (error) {
            console.error("Update operation failed:", error);
          }
        } else {
          try {
            await axios.put(
              "/exasol_data_update",
              {
                data: changedData,
                tableName: dataToLoad.value,
              },
              {
                headers: { Authorization: "Bearer " + localStorage.access },
              }
            );
            console.log("Data was updated successfully");
          } catch (error) {
            console.error("Update operation failed:", error);
          }
        }
      }

      // Check for new rows
      for (const newRow of getAll.value) {
        if (!newRow["index"]) {
          newData.push(newRow);
        }
      }

      if (newData.length > 0) {
        try {
          await axios.post(
            "/exasol_data_create",
            {
              data: newData,
              tableName: dataToLoad.value,
            },
            {
              headers: { Authorization: "Bearer " + localStorage.access },
            }
          );

          // Handle the response here
          console.log("New data was created successfully");
        } catch (error) {
          console.error("Create operation failed:", error);
        }
      }

      console.log("changedData: ", changedData);

      console.log("newData: ", newData);
      await getData();
    };

    const onCellClicked = (event) => {
      const column = event.column;
      const rowData = event.data;

      if (isBooleanColumn(column.colId)) {
        rowData[column.colId] = !rowData[column.colId];
        gridApi.value.applyTransaction({ update: [rowData] });
        console.log("Updated Row Data: ", rowData);
      }
    };

    return {
      onSubmit,
      gridOptions,
      handleAdd,
      mdiPlusBoxOutline,
      mdiMinusBoxOutline,
      mdiCheckboxOutline,
      mdiChevronLeft,
      mdiChevronRight,
      onGridReady,
      deselectRows,
      rowSelection,
      defaultColDef,
      columnDefs,
      columnTypes,
      deleteSelectedRows,
      getAll,
      loadNextPage,
      loadPreviousPage,
      domLayout,
      isLoading,
      totalCount,
      currentCount,
      page,
      pageSize,
      dataToLoad,
      isButtonsDisabled,
      checkboxRenderer,
      dateCellRenderer,
      onCellClicked,
      selectedDate,
      testFilter,
      computedLocaleText,
    };
  },
};
</script>

<style lang="less" scoped>
.ag-theme-alpine {
  --ag-header-height: 45px;
  --ag-borders: solid 1px;
  /* then add back a border between rows */
  --ag-borders-row: dashed 1px;
  --ag-row-border-color: rgba(131, 128, 128, 0.308);
  --ag-cell-horizontal-border: solid 1px rgba(128, 128, 131, 0.288);
  --ag-widget-container-horizontal-padding: 1px;
  --ag-widget-container-vertical-padding: 1px;
  --ag-border-color: rgba(131, 128, 128, 0.181);
  --ag-borders: solid 1px;
  --ag-border-width: 1px;
  /* --ag-borders-secondary: dashed; */
  --ag-font-family: system-ui, serif;
  --ag-header-cell-hover-background-color: rgba(234, 243, 245, 0.722);
  --ag-row-hover-color: rgba(234, 243, 245, 0.722);
  --ag-header-column-resize-handle-height: 100%;
  --ag-header-column-resize-handle-width: 1px;
  // --ag-header-column-resize-handle-color: rgba(131, 128, 128, 0.181);
  --ag-header-column-separator-display: block;
  --ag-header-column-separator-height: 100%;
  --ag-header-column-separator-width: 1px;
  --ag-header-column-separator-color: rgba(131, 128, 128, 0.181);
  --ag-cell-horizontal-padding: 10px;
  /* --ag-header-cell-comp-wrapper:  */
}
.ag-theme-alpine .ag-cell-last-left-pinned {
  border-right: none;
}
.ag-theme-alpine .ag-cell-last-left-pinned {
  background-color: transparent;
}

.content_navbar_main {
  border-bottom: 2px solid #f6f8fc;
}

.filter-icon {
  opacity: 0.2;
  scale: 0.8;
  transition: opacity 0.1s;
}

.content_navbar {
  margin-left: 10px;
  display: flex;
  align-items: center;
  height: 45px;
  color: #444746da;
  // color: #44474646;
  font-size: 14px;
}

.disabled {
  opacity: 0.5;
  pointer-events: none;
}

.content_navbar__info {
  padding-left: 10px;
  display: flex;
  align-items: center;
  color: #444746da;
  font-size: 14px;
}
.dataToLoad {
  font-weight: bold;
  padding-left: 8px;
}

.left-icons {
  display: flex;
  align-items: center;
}

.right-icons {
  margin-left: auto;
  margin-right: 10px;
  display: flex;
  align-items: center;
}

.content_navbar__icons {
  /* padding: 5px;
  padding-top: auto; */
  transition: background-color 0.1s ease;
  border-radius: 8px;
  height: 24px;
  cursor: pointer;
}

.content_navbar__icons:hover {
  /* background-color: rgba(234, 243, 245, 0.722); */
  border-radius: 4px;
  background-color: #0530488a;
  color: #f9f7f3;
}

.content_navbar__pag_icons {
  /* padding: 5px;
  padding-top: auto; */
  transition: background-color 0.1s ease;
  border-radius: 8px;
  height: 24px;
  cursor: pointer;
}

.content_navbar__pag_icons:hover {
  cursor: pointer;
  border-radius: 4px;
  background-color: #0530488a;
  color: #f9f7f3;
  /* height: 24px;
  width: 24px; */
}

.spinner-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%; /* Adjust the height as needed */
  margin-top: 20%;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-left-color: #1a73e8;
  border-radius: 50%;
  animation: spin 1s infinite linear;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
