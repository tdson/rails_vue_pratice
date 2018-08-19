<template lang="html">
  <li class="collection-item">
    <input type="checkbox" :id="`task-${task.id}`"/>
    <label :for="`task-${task.id}`" v-text="task.title"/>
  </li>
</template>

<script>
export default {
  props: ['task'],

  methods: {
    handleChange () {
      this.$emit('task-checked', this.task)
    }
  }
}
</script>
