<template>
  <div class="search-field" @click="showSearchInput = true">
    <svg-icon
      v-if="!showSearchInput"
      class="search-icon"
      type="mdi"
      :path="mdiMagnify"
    ></svg-icon>
    <input
      v-if="showSearchInput"
      ref="searchInput"
      class="search-input"
      type="text"
      v-model="searchTerm"
      @input="handleSearchInput"
      @blur="hideSearchInput"
    />
  </div>
</template>

<script>
import { ref, watch, nextTick } from "vue";
import SvgIcon from "@jamescoyle/vue-icon";
import { mdiMagnify } from "@mdi/js";

export default {
  components: {
    SvgIcon,
  },
  props: {
    nodes: Array,
  },
  setup(props, { emit }) {
    const showSearchInput = ref(false);
    const searchTerm = ref("");
    const searchInput = ref(null); // Define the searchInput ref

    const handleSearchInput = () => {
      emit("search", searchTerm.value);
    };

    const hideSearchInput = () => {
      showSearchInput.value = false;
      searchTerm.value = "";
    };

    const toggleSearchInput = () => {
      showSearchInput.value = true;
      nextTick(() => {
        const inputElement = searchInput.value;
        if (inputElement) {
          inputElement.focus();
        }
      });
    };

    watch(showSearchInput, (newValue) => {
      if (newValue) {
        toggleSearchInput();
      }
    });

    return {
      showSearchInput,
      searchTerm,
      mdiMagnify,
      handleSearchInput,
      hideSearchInput,
      searchInput, // Return the searchInput ref
    };
  },
};
</script>

<style>
.search-field {
  margin: 5px;
  display: flex;
  align-items: center;
  padding: 4px;
  border-radius: 8px;
  background-color: #ffffffb6;
  cursor: pointer;
  /* border-bottom: 2px solid #f6f8fc; */
  border-bottom: 2px solid #44444411;
}

.search-icon {
  width: 20px;
  height: 20px;
  color: #888;
}

.search-input {
  border: none;
  outline: none;
  padding: 4px;
  font-size: 14px;
  color: #444;
  background-color: transparent;
}
</style>
