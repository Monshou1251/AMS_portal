import { createRouter, createWebHashHistory } from "vue-router";
import Login from "@/views/Login";
// import Main from "@/views/Main";
import mainPage from "@/views/MainPage";
import importPage from "@/views/ImportPage";
import importPage_v2 from "@/views/ImportPage_v2";
import TransferPage from "@/views/TransferPage";
import airflowTemplate from "@/views/AirflowTemplate";
import store from "../store";

const routes = [
  {
    path: "/",
    name: "login",
    component: Login,
  },
  {
    path: "/main",
    name: "main",
    component: mainPage,
    meta: { requiresAuth: false },
  },
  {
    path: "/import",
    name: "import",
    component: importPage,
    meta: { requiresAuth: false },
  },
  {
    path: "/import_v2",
    name: "import_v2",
    component: importPage_v2,
    meta: { requiresAuth: false },
  },
  {
    path: "/airflow",
    name: "airflow",
    component: airflowTemplate,
    meta: { requiresAuth: false },
  },
  {
    path: "/transfer",
    name: "transfer",
    component: TransferPage,
    meta: { requiresAuth: false },
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  document.title = 'Портал AMS'
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth);
  // const accessToken = localStorage.getItem("access");
  const accessToken = store.state.access;

  if (requiresAuth && !accessToken) {
    next("/");
  } else {
    next();
  }
});

export default router;
