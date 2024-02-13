import { createStore } from "vuex";
import axios from "axios";

export default createStore({
  state: {
    access: "",
    refresh: "",
    isAuthorized: false,
    dataToLoad: null,
    tables: [
      'AMS_GL.INTEGRATION_CODE',
      'AMS_GL.SOURCE_SYSTEM',
      'AMS_GL.DEPARTMENT',
      'AMS_GL.CURRENCY',
      'AMS_GL.CURRENCY_TYPE',
      'AMS_GL.SUBJECT',
      'AMS_GL.SUBJECT_PHYSICAL',
      'AMS_GL.SUBJECT_JURIDICAL',
      'AMS_GL.INS_CONTRACT',
      'AMS_GL.INS_POLICY',
      'AMS_GL.REINS_CONTRACT',
      'AMS_GL.LPU_INVOICE',
      'AMS_GL.CLAIM_STATEMENT',
      'AMS_GL.INS_OBJECT_TYPE',
      'AMS_GL.PL_CODE',
      'AMS_GL.BUSINESS_LINE',
      'AMS_GL.GL_ACCOUNT_2',
      'AMS_GL.GL_ACCOUNT_5',
      'AMS_GL.GL_ACCOUNT',
      'AMS_GL.GL_DIMENSION',
    ],
    currentUser: localStorage.getItem("currentUser") || null,
    userPermissions:
      JSON.parse(localStorage.getItem("userPermissions")) || null,
    appliedFilters: {
    },
    // sorting: {},
    sorting: {
      columnName: null,
      direction: null,
    }
  },
  mutations: {
    initializeStore(state) {
      if (localStorage.getItem("access")) {
        state.access = localStorage.getItem("access");
        state.refresh = localStorage.getItem("refresh");
      } else {
        state.access = "";
        state.refresh = "";
      }
    },
    setAccess(state, access) {
      state.access = access;
    },
    setRefresh(state, refresh) {
      state.refresh = refresh;
    },
    setIsAuth(state) {
      state.isAuthorized = true;
    },
    setNotAuth(state) {
      state.isAuthorized = false;
      state.access = "";
      state.refresh = "";
    },
    setCurrentUser(state, username) {
      state.currentUser = username;
      localStorage.setItem("currentUser", username);
    },
    // mutation to switch components on a mainpage
    setDataToLoad(state, dataToLoad) {
      state.dataToLoad = dataToLoad;
    },
    setUserPermissions(state, permissions) {
      state.userPermissions = permissions;
      localStorage.setItem("userPermissions", JSON.stringify(permissions));
    },
    ADD_FILTER(state, { columnName, filterType, filterValue }) {
      // if (!state.appliedFilters[tableName]) {
      //   state.appliedFilters[tableName] = {}
      // }
      // if (!state.appliedFilters[tableName][columnName]) {
      //   state.appliedFilters[tableName][columnName] = []
      // }
      if (!state.appliedFilters[columnName]) {
        state.appliedFilters[columnName] = []
      }
      // state.appliedFilters[tableName][columnName].push({ type: filterType, value: filterValue })
      state.appliedFilters[columnName].push({ type: filterType, value: filterValue })
    },
    REMOVE_FILTER(state, columnName) {
      delete state.appliedFilters[columnName]
    },
    SET_SORTING(state, { columnName, direction}) {
      state.sorting.columnName = columnName
      state.sorting.direction = direction
    },
    CLEAR_SORTING(state) {
      state.sorting.columnName = null
      state.sorting.direction = null
    },
  },
  actions: {
    async fetchUserPermissions({ commit, state }) {
      try {
        const response = await axios.get(
          `/user_permissions/${state.currentUser}`,
          {
            headers: { Authorization: "Bearer " + localStorage.access },
          }
        );
        console.log("Data from action", response.data);
        const userPermissions = response.data.data;
        commit("setUserPermissions", userPermissions);
      } catch (error) {
        console.error(error);
      }
    },
    applyFilter({commit}, filterData) {
      commit('ADD_FILTER', filterData)
    },
    clearFilter({commit}) {
      commit('CLEAR_SORTING')
    },
    applySorting({commit}, {columnName, direction}) {
      commit('SET_SORTING', {columnName, direction})
    },
    clearSorting({commit}) {
      commit('CLEAR_SORTING')
    }
  },

  getters: {},
  modules: {},
});
