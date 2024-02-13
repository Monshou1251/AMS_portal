<template>
    <div class="custom-filter">
        <div class="popup-inputs">
            <select v-model="filterType" name="" id="">
                <option value="contains">содержит</option>
                <option value="equals">равно</option>
            </select>
                
            <input type="text" v-model="inputValue">
        </div>
        <div class="popup-buttons">
            
            <button class="button1" @click="addFilter">Применить</button>
            <button class="button2" @click="removeFilter">Сбросить</button>
        </div>
        <div ref="filterIcon" @click="openFilterModal" class="icon-wrapper">
            <!-- <svg-icon  class="filter-icon"  type="mdi" :path="mdiFilterVariant">
            </svg-icon> -->
            <div v-if="hasFilters">
                Примененные фильтры:
            </div>
            <li v-for="item in appliedFilters" :key="item">
                {{ item['type'] }}: {{ item['value'] }}
            </li>
        </div>
    </div>
</template>

<script setup>
import { computed, ref, defineProps } from 'vue'
// import { defineProps, computed } from 'vue'
// import SvgIcon from '@jamescoyle/vue-icon'
// import { mdiFilterVariant } from '@mdi/js'
import { useStore } from 'vuex'

const props = defineProps({
    params: Object,
})


const store = useStore()
const inputValue = ref('')
const columnName = ref(props.params.column.colId)
const filterType = ref('equals')

const hasFilters = computed(() => {
    const filters = store.state.appliedFilters[columnName.value]
    return filters && filters.length > 0
})

// const isFilterActive = () => {
//     const currentFilters = store.state.appliedFilters[columnName.value]
//     return 
// }

const appliedFilters = computed(() => {
    return store.state.appliedFilters[columnName.value] || []
})

const addFilter = () => {
    const filterData = {
        // tableName: store.state.dataToLoad,
        columnName: columnName.value,
        filterType: filterType.value,
        filterValue: inputValue.value 
    }
    store.dispatch('applyFilter', filterData)
    // props.params.api.setFilterModel(store.state.appliedFilters[columnName.value])
    // if (props.params.api) {
    //     props.params.api.onFilterChanged()
    // }
}



const removeFilter = () => {
    // store.commit("REMOVE_FILTER", store.state.dataToLoad, columnName.value)
    store.commit("REMOVE_FILTER", columnName.value)
}


</script>
<style>
    .ag-menu.ag-ltr.ag-popup-child {
        padding: 5px;
        /* width: 180px; */
    }
    .popup-inputs {
        display: flex;
        flex-direction: column;
    }
    .popup-buttons {
        display: flex;
        /* flex-direction: column; */
        gap: 10px;
    }

    .popup-buttons button {
        width: 100%;
        cursor: pointer;
        /* background-color: #e94f376e; */
        background-color: #0530487c;
        /* border: none; */
        height: 30px;
        border-radius: 4px;
        font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;

    }


    .popup-buttons .button1 {
        /* background-color: #0530488a; */
        border: none;
        color: white;
        font-weight: 400;
    }

    .popup-buttons .button1:hover {
        background-color: #053048b6;
    }
    .popup-buttons .button2:hover {
        border-color: #053048b1;
        color: #556771e5;
    }

    .popup-buttons .button2 {
        background-color: white;
        border: solid;
        border-color: #0530487c;
        font-weight: 600;
        color: #053048d2;
    }

    .ag-menu.ag-ltr.ag-popup-child input, select {
        margin-bottom: 5px;
        width: 100%;
        height: 25px;
        box-sizing: border-box;
        outline: #05304822;
        border: 1px solid #05304858;
        border-radius: 3px;
    }

    .ag-menu.ag-ltr.ag-popup-child li {
        list-style-type: none;
    }
    .custom-filter {
        /* padding: 20px; */
        /* flex: 1; */
        /* position:relative; */
        display: flex;
        align-items: flex;
        justify-content: space-between;
        flex-direction: column;
        /* padding: 5px; */
        color: #444746da;
        /* background-color: red; */
    }

    .filter-icon {
        opacity: 0.2;
        scale: 0.8;
        transition: opacity 0.1s;
    }

    .filter-icon:hover {
        opacity: 1;
        cursor: pointer;
    }

</style>