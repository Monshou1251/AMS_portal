<template>
  <div>
    <SearchField />
  </div>
  <div class="mainTree__main">
    <TreeNode :nodes="parents" />
  </div>
</template>

<script>
/* eslint-disable */
import { ref, computed } from "vue";
import { useStore } from "vuex";
import TreeNode from "@/components/Sidebars/RecursiveComp/TreeNode.vue";
import SearchField from "@/components/Sidebars/RecursiveComp/SearchField.vue";
import {
  mdiFolderOutline,
  mdiFolderOpenOutline,
  mdiDatabaseExportOutline,
  mdiFileCodeOutline,
  mdiSourcePull,
  mdiCalendarCollapseHorizontalOutline,
  mdiRelationZeroOrManyToZeroOrMany,
  mdiClipboardTextClockOutline,
  mdiAbacus,
  mdiCalculatorVariantOutline,
  mdiArchiveRemoveOutline,
  mdiMicrosoftExcel,
  mdiAccountBoxOutline,
  mdiCalendarCheckOutline,
  mdiCalendarRemoveOutline,

} from "@mdi/js";

export default {
  components: {
    TreeNode,
    SearchField,
  },
  setup() {
    const store = useStore();

    const parents = ref([
      {
        name: "Просмотр таблиц AMS",
        isOpen: false,
        icon: "mdi-folder-open-outline",
        children: [
          {
            name: "AMS_GL.BUSINESS_LINE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.BUSINESS_LINE",
          },
          {
            name: "AMS_GL.CLAIM_STATEMENT",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.CLAIM_STATEMENT",
          },
          {
            name: "AMS_GL.COOLOFF_PARTNER",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.COOLOFF_PARTNER",
          },
          {
            name: "AMS_GL.COOLOFF_PRODUCT",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.COOLOFF_PRODUCT",
          },
          {
            name: "AMS_GL.CURRENCY",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.CURRENCY",
          },
          {
            name: "AMS_GL.CURRENCY_RATE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.CURRENCY_RATE",
          },
          // {
          //   name: "AMS_GL.CUR_REVAL_RULES",
          //   icon: mdiDatabaseExportOutline,
          //   isOpen: false,
          //   router: "AMS_GL.CUR_REVAL_RULES",
          // },
          {
            name: "AMS_GL.DEPARTMENT",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.DEPARTMENT",
          },
          // {
          //   name: "AMS_GL.DGL_ENTRY_EXCEPTIONS",
          //   icon: mdiDatabaseExportOutline,
          //   isOpen: false,
          //   router: "AMS_GL.DGL_ENTRY_EXCEPTIONS",
          // },
          {
            name: "AMS_GL.ENTRY_TYPE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.ENTRY_TYPE",
          },
          {
            name: "AMS_GL.GL_ACCOUNT",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.GL_ACCOUNT",
          },
          // ___
          {
            name: "AMS_GL.GL_ACCOUNT_2",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.GL_ACCOUNT_2",
          },
          {
            name: "AMS_GL.GL_ACCOUNT_5",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.GL_ACCOUNT_5",
          },
          {
            name: "AMS_GL.GL_DIMENSION",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.GL_DIMENSION",
          },
          {
            name: "AMS_GL.INS_CONTRACT",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.INS_CONTRACT",
          },
          {
            name: "AMS_GL.INS_OBJECT_TYPE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.INS_OBJECT_TYPE",
          },
          {
            name: "AMS_GL.INS_POLICY",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.INS_POLICY",
          },
          {
            name: "AMS_GL.INS_RESERVE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.INS_RESERVE",
          },
          {
            name: "AMS_GL.INTEGRATION_CODE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.INTEGRATION_CODE",
          },
          {
            name: "AMS_GL.INT_CODE_MAP",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.INT_CODE_MAP",
          },
          // {
          //   name: "AMS_GL.LPU_INVOICE",
          //   icon: mdiDatabaseExportOutline,
          //   isOpen: false,
          //   router: "AMS_GL.LPU_INVOICE",
          // },
          {
            name: "AMS_GL.PAIRED_ACCOUNTS",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.PAIRED_ACCOUNTS",
          },
          {
            name: "AMS_GL.PAYDOC",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.PAYDOC",
          },
          {
            name: "AMS_GL.PAY_INT_CODE_MAP",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.PAY_INT_CODE_MAP",
          },
          {
            name: "AMS_GL.PL_ITEM",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.PL_ITEM",
          },
          {
            name: "AMS_GL.PROVISION",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.PROVISION",
          },
          {
            name: "AMS_GL.SETTLEMENT_TYPE",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.SETTLEMENT_TYPE",
          },
          {
            name: "AMS_GL.SOURCE_SYSTEM",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.SOURCE_SYSTEM",
          },
          {
            name: "AMS_GL.SUBJECT",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.SUBJECT",
          },
          {
            name: "AMS_GL.SUBJECT_1C",
            icon: mdiDatabaseExportOutline,
            isOpen: false,
            router: "AMS_GL.SUBJECT_1C",
          },
        ],
      },
      {
        name: "Редактирование таблиц AMS",
        isOpen: false,
        icon: "mdi-folder-open-outline",
        router: "AMS_GL.ACC_PERIODS",
        children: [
          {
            name: "AMS_GL.ACC_PERIODS",
            icon: mdiDatabaseExportOutline,
            router: "AMS_GL.ACC_PERIODS",
          },
          
          
        ],
      },
      {
        name: "Импорт проводок в AMS",
        isOpen: false,
        icon: "mdi-folder-open-outline",
        children: [
          {
            name: "Импорт проводок из MS Excel",
            icon: mdiMicrosoftExcel,
            isOpen: false,
            router: "FileUploader",
          },
          {
            name: "Деактивация загруженных проводок",
            icon: mdiMicrosoftExcel,
            isOpen: false,
            router: "CancelTransfer",
          },
        ],
      },
      {
        name: "Процедура закрытия периода",
        isOpen: false,
        icon: "mdi-folder-open-outline",
        children: [
          {
            name: "Генерация проводок закрытия периода",
            icon: mdiCalendarCheckOutline,
            isOpen: false,
            router: "GenerateTransfer",
          },
          {
            name: "Деактивация проводок закрытия периода",
            icon: mdiCalendarRemoveOutline,
            isOpen: false,
            router: "CancelTransferAMS",
          },
        ],
      },
      // {
      //   name: "Редактирование пользователей",
      //   isOpen: false,
      //   icon: "mdi-folder-open-outline",
      //   children: [
      //     {
      //       name: "Права пользователей",
      //       icon: mdiAccountBoxOutline,
      //       isOpen: false,
      //       router: "ams_cfg.user_access",
      //     },
      //     {
      //       name: "Пользователи",
      //       icon: mdiAccountBoxOutline,
      //       isOpen: false,
      //       router: "ams_cfg.users",
      //     },
      //     {
      //       name: "Таблицы",
      //       icon: mdiAccountBoxOutline,
      //       isOpen: false,
      //       router: "ams_cfg.portal_sheets",
      //     },
      //     {
      //       name: "test_table_stg",
      //       icon: mdiAccountBoxOutline,
      //       isOpen: false,
      //       router: "stg.test_table_stg",
      //     },
      //     {
      //       name: "table_no_id",
      //       icon: mdiAccountBoxOutline,
      //       isOpen: false,
      //       router: "stg.table_no_id",
      //     },
      //   ],
      // },
    ]);

    const userPermissions = computed(() => store.state.userPermissions);

    const hasPermission = (itemName) => {
      if (!userPermissions.value) return false;

      const formattedItemName = itemName && itemName.toLowerCase();
      const userPermission = userPermissions.value.find(
        (permission) =>
          permission.sheet_name.toLowerCase() === formattedItemName
      );

      // Grant access if user is an Admin
      if (store.state.currentUser === "admin" || store.state.currentUser == null) {
        return true;
      }

      return userPermission ? userPermission.allowed : false;
    };

    // If the item does not have children, check if the user has permission to access it
    // If the item has children, recursively modify its children based on permissions
    // Hide the item if all its children are hidden (no permissions)

    const modifySidebarData = (items) => {
      return items.filter((item) => {
        if (!item.children) {
          return hasPermission(item.router);
        } else {
          item.children = modifySidebarData(item.children);
          return item.children.length > 0;
        }
      });
    };

    // parents.value = modifySidebarData(parents.value);

    return {
      parents,
      mdiFolderOutline,
      mdiFolderOpenOutline,
      mdiDatabaseExportOutline,
      mdiFileCodeOutline,
      mdiSourcePull,
      mdiCalendarCollapseHorizontalOutline,
      mdiRelationZeroOrManyToZeroOrMany,
      mdiClipboardTextClockOutline,
      mdiAbacus,
      mdiCalculatorVariantOutline,
      mdiArchiveRemoveOutline,
      mdiMicrosoftExcel,
      mdiAccountBoxOutline,
      mdiCalendarCheckOutline,
      mdiCalendarRemoveOutline,

    };
  },
};
</script>
<style>
.mainTree__main {
  margin-top: 10px;
  margin-left: 5px;
  margin-left: 10px;
}
</style>
