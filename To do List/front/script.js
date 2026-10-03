function addTask(task, tasksArray) {
const newTask = document.createElement("li");
newTask.textContent = task;
tasksArray.push(newTask);
}
