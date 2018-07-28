# Instructions
A sample API server has been prepared.

Run theses commands bellow to create the database, load the schema and initialize it with the seed data.

```sh
rails db:setup
rails s
```

# API guide

| Action  | Verb   | URI Pattern    | Example payload                                   |
|---------|--------|----------------|---------------------------------------------------|
| Index   | GET    | /api/tasks     |                                                   |
| Create  | POST   | /api/tasks     | `{'task': {'title': 'some text'}}`                |
| Show    | GET    | /api/tasks/:id |                                                   |
| Update  | PUT    | /api/tasks/:id | `{'task': {'title': 'changes', 'is_done': true}}` |
| Destroy | DELETE | /api/tasks/:id |                                                   |
