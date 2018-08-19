<template>
  <div>
    <div>
      <ul class="collection">
        <task v-for="task in finishedTasks" :key="task.id" :task="task"/>
      </ul>
    </div>
    <div class="btn">Display finished tasks</div>
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <task v-for="task in unfinishedTasks" :key="task.id" :task="task"/>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Task from '../components/task'

export default {
  data: function () {
    return {
      tasks: []
    }
  },

  components: {
    Task
  },

  computed: {
    finishedTasks: function () {
      return this.tasks.filter(task => task.is_done)
    },

    unfinishedTasks: function () {
      return this.tasks.filter(task => !task.is_done)
    }
  },

  mounted: function () {
    this.fetchTasks()
  },

  methods: {
    fetchTasks: function () {
      axios.get('/api/tasks').then(
        response => { this.tasks = response.data.tasks },
        error => alert(error)
      )
    }
  }
}
</script>
