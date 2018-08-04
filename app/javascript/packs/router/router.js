import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'

import Home from '../pages/home.vue'
import About from '../pages/about.vue'
import Contact from '../pages/contact.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Home },
    { path: '/about', component: About },
    { path: '/contact', component: Contact },
  ],
})
