function addTask(task, tasksArray) {
const newTask = document.createElement("li");
newTask.textContent = task;
tasksArray.push(newTask);

if (task === "") {
                alert("Digite uma tarefa antes de adicionar.");
                return;
            }
      }

tasks.push(task);

function renderTasks() {
            const list = document.getElementById("taskList");
            list.innerHTML = ""; // limpa a lista

            tasks.forEach((tarefa) => {
                const li = document.createElement("li");
                li.textContent = tarefa;
                list.appendChild(li);
            });
        }function renderTasks() {
            const list = document.getElementById("taskList");
            list.innerHTML = "";

            tasks.forEach((tarefa) => {
                const li = document.createElement("li");
                li.textContent = tarefa;
                list.appendChild(li);
            });
        }
 renderTasks();
