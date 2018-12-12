<template lang="html">
  <li class="collection-item">
    <label :for="`task-${task.id}`">
      <input type="checkbox" :id="`task-${task.id}`" :checked="task.is_done" @change="toggleFinish"/>
      <span v-text="task.title"></span>
    </label>
    <i class="material-icons" @click="deleteTask">delete</i>
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
     },
     deleteTask (){
       const id = this.task.id
       this.$emit('deleteTask', id)
     }
   }
}
</script>
