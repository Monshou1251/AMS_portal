<template>
    <div class="custom-header" >
        <div class="header-title" @click="toggleSorting">
            <div>{{ params.displayName }}</div>
            <div class="header-arrow" >
                <svg-icon
                    type="mdi"
                    v-if="store.state.sorting.columnName === columnName"
                    :path="sortIconPath"
                ></svg-icon>
            </div>

        </div>
        <div :class="iconStyle" ref="filterButton" @click="openFilterPanel">
            <svg-icon type="mdi" :path="mdiFilterVariant">

            </svg-icon>
        </div>
    </div>
</template>

<script setup>
import { computed, ref, defineProps } from 'vue'
// import { defineProps, computed } from 'vue'
import SvgIcon from '@jamescoyle/vue-icon'
import { mdiFilterVariant, mdiArrowUp, mdiArrowDown } from '@mdi/js'
import { useStore } from 'vuex'

const props = defineProps({
    params: Object,
})
const store = useStore()
const columnName = ref(props.params.column.colId)

// FILTERING_BLOCK_____________________________________________________________________
const filterButton = ref(null)

const hasFilters = computed(() => {
    const filters = store.state.appliedFilters[props.params.column.colId]
    return filters && filters.length > 0
})

const iconStyle = computed(() => {
    return (hasFilters.value ?  'custom-header-icon1': 'custom-header-icon2')
})

const openFilterPanel = () => {
    if (filterButton.value && props.params.api && props.params.column) {
        const column = props.params.column
        props.params.api.showColumnMenuAfterButtonClick(column, filterButton.value)
    }
}
// FILTERING_BLOCK_____________________________________________________________________

// SORTING BLOCK_____________________________________________________________________
// const sortState = ref(null)
// const sortingState = computed(() => store.state.sorting.direction)

const sortIconPath = computed(() => {
    const sorting = store.state.sorting
    if (sorting.columnName === columnName.value) {
        return sorting.direction === 'asc' ? mdiArrowUp : mdiArrowDown
    }
    return ''
    // if (store.state.sorting.direction == 'asc') {
    //     return mdiArrowUp
    // } else if (store.state.sorting.direction === 'desc') {
    //     return mdiArrowDown
    // } else {
    //     return ''
    // }
})
const toggleSorting = () => {
    const currentSort = store.state.sorting
    let newDirection = 'asc'

    if (currentSort.columnName === columnName.value) {
        newDirection = currentSort.direction === 'asc' ? 'desc' : null
    }

    if (newDirection) {
        store.dispatch('applySorting', {
            columnName: columnName.value,
            direction: newDirection,
        })
    } else {
        store.dispatch('clearSorting')
    }
    // if (sortState.value == null) {
    //     sortState.value = 'asc'
    //     store.dispatch('applySorting', {
    //         columnName: columnName.value,
    //         direction: sortState.value,
    //     })
    //     console.log(store.state.sorting.direction)
    // } else if (sortState.value == 'asc') {
    //     sortState.value = 'desc'
    //     store.dispatch('applySorting', {
    //         columnName: columnName.value,
    //         direction: sortState.value,
    //     })
    //     console.log(store.state.sorting.direction)
    // } else {
    //     sortState.value = null
    //     store.commit('CLEAR_SORTING')
    //     console.log('CLEAR_SORTING')
    //     console.log(store.state.sorting.direction)
    // }
}



</script>
<style>
.custom-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-direction: row;
    color: #444746da;
    width: 100%;
    cursor: pointer;
}

.header-title {
    display: flex;
    align-items: center;
}

.header-arrow {
    scale: 0.8;
}

.custom-header-icon1 {
    display: flex;
    align-items: center;
    padding-right: 10px;
    font-size: 16px;
    opacity: 1;
    scale: 0.8;
}

.custom-header-icon2 {
    display: flex;
    align-items: center;
    padding-right: 10px;
    font-size: 16px;
    opacity: 0.1;
    scale: 0.8;
}

.custom-header-icon2:hover {
    opacity: 0.9;
    cursor: pointer;
    scale: 0.8;
}
.custom-header-icon1:hover {
    opacity: 0.9;
    cursor: pointer;
    scale: 0.8;
}

</style>