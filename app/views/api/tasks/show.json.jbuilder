json.set! :task do
  json.extract! @task, :id, :title, :is_done
  json.created_at time_ago_in_words(@task.created_at)
  json.updated_at time_ago_in_words(@task.updated_at)
end
