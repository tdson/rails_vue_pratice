<template>
  <div>
    <div>
      <input v-model="new_task.title">
      <div class="btn" @click="createTask">add Task</div>
    </div>
    <div>
      <ul class="collection">
        <task v-for="task in unfinishedTasks" :key="task.id" :task="task" @toggleFinish="updateTask" @deleteTask="destroyTask"/>
      </ul>
    </div>
    <div class="btn">Display finished tasks</div>
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <task v-for="task in finishedTasks" :key="task.id" :task="task" @toggleFinish="updateTask" @deleteTask="destroyTask"/>
      </ul>
    </div>
  </div>
</template>
<script>
  import axios from 'axios'
  import Task from '../components/task'

  export default {
    data (){
      return {
        tasks: [],
        new_task: {
          title: '',
          is_done: false
        }
      }
    },

    computed: {
      finishedTasks: function () {
        return this.tasks.filter(task => task.is_done)
      },

      unfinishedTasks: function () {
        return this.tasks.filter(task => !task.is_done)
      }
    },

    components: { Task },

    mounted: function () {
      this.fetchTasks()
     },

    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks').then(
          response => { this.tasks = response.data.tasks },
          error => alert(error))
      },

      updateTask: function ({task, value}) {
        const data = {
          task: { is_done: value }
        }
        axios.put(`/api/tasks/${task.id}`, data).then(
        response => {
          const index = this.tasks.indexOf(task)
          this.tasks.splice(index, 1, response.data.task)
        },
        error => alert(error))
      },

      createTask: function (){
        axios.post('api/tasks', this.new_task),
        error => alert(error),
        this.fetchTasks()
      },

      destroyTask: function (id){
        axios.delete(`api/tasks/${id}`),
        error => alert(error),
        this.fetchTasks()
      }
     }
  }
</script>
