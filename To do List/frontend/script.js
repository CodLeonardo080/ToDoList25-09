const tasks = [];

function addTask() {
    const input = document.getElementById("taskInput");
    const task = input.value.trim();

    if (task === "") {
        alert("Digite uma tarefa antes de adicionar.");
        return;
    }

    tasks.push(task);
    input.value = "";
    renderTasks();
}

function renderTasks() {
    const list = document.getElementById("taskList");
    list.innerHTML = "";

task.forEach((tarefa, index) => {
    const li = document.createElement("li");
    li. textContent = tarefa + " ";

    const botaoExcluir = document.createElement("button");
    botaoExcluir.textContent + "Excluir";

    botaoExcluir.addEventListener("click", function() {
        removerTarefa(index);
    });

    li.appendChild(botaoExcluir);
    list.appendchild(li);
});
}

function removerTarefa(index) {
    const confirmar = confirm(
        "tem ceretza de que deseja excluir esta tarefa?"
    );

if (confirmar) {
    tasks.splice(index, 1);
    renderTasks();
    alert("Tarefa removida com sucesso!");
}
}

renderTasks();
