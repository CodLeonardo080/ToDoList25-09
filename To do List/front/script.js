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

    tasks.forEach((tarefa) => {
        const li = document.createElement("li");
        li.textContent = tarefa;
        list.appendChild(li);
    });
}

renderTasks();

const botaoExcluir = document.createElement("button");
botaoExcluir.textContent = "excluir";

botaoExcluir.addEventListener("click", function() {
    tarefa.remove();
});
tarefa.appendChild(botaoexcluir);

const botaoConcluir = document.createElement("button");
botaoConcluir.textContent = "concluir";

botaoConcluir.addEventListener("click", function() {
    tarefa.classlist.toggle("concluida");

    if (tarefa.classlist.contains("concluida")) {
        botaoConcluir.textContent = "desfazer";
    } else {
        botaoConcluir.textContent = "concluir";
    }
});
tarefa.appendChild(botaoConcluir);

