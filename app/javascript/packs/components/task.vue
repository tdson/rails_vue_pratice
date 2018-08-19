<template lang="html">
  <li class="collection-item">
    <input type="checkbox" :id="`task-${task.id}`" :checked="task.is_done" v-on:change="toggleFinish"/>
    <label :for="`task-${task.id}`" v-text="task.title"/>
  </li>
</template>

<script>
export default {
  props: ['task'],

  methods: {
    toggleFinish (e) {
      const payload = {
        task: this.task,
        value: e.target.checked
      }
      this.$emit('toggleFinish', payload)
    }
  }
}
</script>
