<template>
  <div class="">
    <div v-for="(node, index) in nodes" :key="index">
      <div class="parent" @click="toggleNode(node)">
        <svg-icon class="icons" type="mdi" :path="node.icon"></svg-icon>
        <div v-if="node.router">
          <div @click="changeComponent(node.router)">
            {{ node.name }}
          </div>
        </div>
        <div v-else>
          {{ node.name }}
        </div>
      </div>
      <div v-if="node.isOpen" class="child">
        <TreeNode :nodes="node.children" />
      </div>
    </div>
  </div>
</template>

<script>
import { computed } from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
import { mdiFolderOutline, mdiFolderOpenOutline } from "@mdi/js";
import { useStore } from "vuex";

export default {
  components: {
    SvgIcon,
  },
  props: {
    nodes: Array,
  },
  setup(props) {
    const store = useStore();

    const toggleNode = (node) => {
      if (node.children) {
        node.isOpen = !node.isOpen;
      }
    };
    const changeComponent = (componentName) => {
      store.commit("setDataToLoad", componentName);
    };

    const updateIcons = (nodes) => {
      nodes.forEach((node) => {
        if (node.children) {
          const icon = computed(() => {
            return node.isOpen ? mdiFolderOpenOutline : mdiFolderOutline;
          });
          node.icon = icon;
          updateIcons(node.children);
        }
      });
    };

    updateIcons(props.nodes);

    return {
      toggleNode,
      mdiFolderOutline,
      mdiFolderOpenOutline,
      changeComponent,
    };
  },
};
</script>

<style>
.parent {
  cursor: pointer;
  display: flex;
  align-items: center;
  white-space: nowrap;
  overflow: hidden;
  font-size: 14px;
  padding-bottom: 1px;
}

.parent:hover {
  /* background-color: rgba(207, 228, 235, 0.642); */
  background-color: #0530485e;
  color: #f9f7f3;
  border-radius: 2px;

}

.icons {
  width: 20px;
  height: 20px;
  justify-content: center;
  margin-right: 5px;
  flex-shrink: 0;
}

.child {
  margin-left: 30px;
  cursor: pointer;
}

.child-item {
  display: flex;
  align-items: center;
}

.grandchild {
  margin-left: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
}

.grandchild-item {
  margin-left: 20px;
  display: flex;
  align-items: center;
}
</style>
