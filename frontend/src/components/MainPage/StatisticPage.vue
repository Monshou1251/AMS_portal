<template>
  <div class="random-statistic">
    <img class="image" src="@\assets\main_page.png" alt="">
  </div>
  <!-- <div></div> -->
</template>

<script>
import { ref } from "vue";

export default {
  name: "StatisticPage",
  setup() {
    const statistic = ref(null);
    const barHeight = ref(20);

    const generateStatistic = () => {
      const randomValue = Math.floor(Math.random() * 100);
      statistic.value = randomValue;
      barHeight.value = randomValue;
    };

    return {
      statistic,
      generateStatistic,
      barHeight,
    };
  },
};
</script>

<style scoped>
.random-statistic {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  /* box-sizing: border-box; */
  /* padding: 20px; */
}

.random-statistic img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;

}
</style>
