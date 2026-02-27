<!DOCTYPE html>
<html>
<head>
  <meta charset=\"UTF-8\" />
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
  <title>TODO List</title>
  <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css\" />
  <style>
    html, body {
      height: 100%;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Arial, sans-serif;
    }
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 20px;
      background: linear-gradient(135deg, #111827, #1f2937, #0f172a);
      color: #fff;
    }
    .card {
      width: min(600px, 95vw);
      padding: 36px 32px;
      border-radius: 20px;
      background: rgba(255,255,255,0.08);
      box-shadow: 0 20px 60px rgba(0,0,0,0.35);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,0.12);
    }
    h1 {
      margin: 0 0 30px;
      font-size: 36px;
      letter-spacing: 0.5px;
      text-align: center;
    }
    .task-input-container {
      display: flex;
      gap: 10px;
      margin-bottom: 30px;
    }
    #newTaskInput {
      flex: 1;
      padding: 12px 16px;
      border: 1px solid rgba(255,255,255,0.2);
      border-radius: 8px;
      background: rgba(255,255,255,0.08);
      color: #fff;
      font-size: 14px;
      transition: all 0.3s ease;
    }
    #newTaskInput:focus {
      outline: none;
      border-color: rgba(255,255,255,0.4);
      background: rgba(255,255,255,0.12);
    }
    #newTaskInput::placeholder {
      color: rgba(255,255,255,0.5);
    }
    #addTaskBtn {
      padding: 12px 20px;
      border: none;
      border-radius: 8px;
      background: rgba(59, 130, 246, 0.8);
      color: #fff;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      gap: 8px;
      white-space: nowrap;
    }
    #addTaskBtn:hover {
      background: rgba(59, 130, 246, 1);
      transform: translateY(-2px);
    }
    #tasksList {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .task-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 14px 16px;
      margin-bottom: 10px;
      border-radius: 8px;
      background: rgba(255,255,255,0.05);
      border: 1px solid rgba(255,255,255,0.1);
      transition: all 0.2s ease;
    }
    .task-item:hover {
      background: rgba(255,255,255,0.08);
      border-color: rgba(255,255,255,0.2);
    }
    .task-item.completed .task-title {
      text-decoration: line-through;
      opacity: 0.6;
    }
    .task-item.editing {
      background: rgba(255,255,255,0.08);
    }
    .task-checkbox {
      width: 20px;
      height: 20px;
      cursor: pointer;
      accent-color: #3b82f6;
      flex-shrink: 0;
    }
    .task-title {
      flex: 1;
      font-size: 15px;
      word-break: break-word;
    }
    .task-title-input {
      flex: 1;
      padding: 8px 12px;
      border: 1px solid rgba(59, 130, 246, 0.5);
      border-radius: 4px;
      background: rgba(255,255,255,0.08);
      color: #fff;
      font-size: 15px;
      font-family: inherit;
    }
    .task-title-input:focus {
      outline: none;
      border-color: rgba(59, 130, 246, 1);
    }
    .task-actions {
      display: flex;
      gap: 8px;
      flex-shrink: 0;
    }
    .edit-btn, .delete-btn, .save-btn, .cancel-btn {
      background: none;
      border: none;
      color: #fff;
      cursor: pointer;
      padding: 6px 8px;
      font-size: 16px;
      transition: all 0.2s ease;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .edit-btn:hover {
      color: #60a5fa;
      transform: scale(1.15);
    }
    .delete-btn:hover {
      color: #ef4444;
      transform: scale(1.15);
    }
    .save-btn:hover {
      color: #10b981;
      transform: scale(1.15);
    }
    .cancel-btn:hover {
      color: #f87171;
      transform: scale(1.15);
    }
    .empty-state {
      text-align: center;
      padding: 40px 20px;
      opacity: 0.7;
    }
    .empty-state i {
      font-size: 48px;
      margin-bottom: 16px;
      display: block;
    }
    .loading {
      text-align: center;
      padding: 20px;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1><i class="bi bi-check2-square"></i> TODO List</h1>
    
    <div class="task-input-container">
      <input 
        type="text" 
        id="newTaskInput" 
        placeholder="Add a new task..." 
        autocomplete="off"
      />
      <button id="addTaskBtn">
        <i class="bi bi-plus-lg"></i> Add
      </button>
    </div>

    <div id="loadingSpinner" class="loading">
      <i class="bi bi-hourglass-split"></i> Loading tasks...
    </div>

    <ul id="tasksList" style="display: none;"></ul>

    <div id="emptyState" class="empty-state" style="display: none;">
      <i class="bi bi-inbox"></i>
      <div>No tasks yet. Create one to get started!</div>
    </div>
  </div>

  <script>
    const API_URL = '/my-webapp-project/api/tasks';
    const tasksList = document.getElementById('tasksList');
    const newTaskInput = document.getElementById('newTaskInput');
    const addTaskBtn = document.getElementById('addTaskBtn');
    const loadingSpinner = document.getElementById('loadingSpinner');
    const emptyState = document.getElementById('emptyState');

    // Load tasks on page load
    loadTasks();

    // Event listeners
    addTaskBtn.addEventListener('click', addTask);
    newTaskInput.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') addTask();
    });

    async function loadTasks() {
      try {
        const response = await fetch(API_URL);
        if (!response.ok) throw new Error('Failed to load tasks');
        
        const tasks = await response.json();
        displayTasks(tasks);
      } catch (error) {
        console.error('Error loading tasks:', error);
        loadingSpinner.innerHTML = '<i class="bi bi-exclamation-triangle"></i> Error loading tasks';
      }
    }

    function displayTasks(tasks) {
      loadingSpinner.style.display = 'none';
      
      if (tasks.length === 0) {
        tasksList.style.display = 'none';
        emptyState.style.display = 'block';
        return;
      }

      emptyState.style.display = 'none';
      tasksList.style.display = 'block';
      tasksList.innerHTML = '';

      tasks.forEach(task => {
        const li = createTaskElement(task);
        tasksList.appendChild(li);
      });
    }

    function.createTaskElement(task) {
      const li = document.createElement('li');
      li.className = 	ask-item ;
      li.dataset.id = task.id;

      li.innerHTML = 
        <input type="checkbox" class="task-checkbox"  />
        <span class="task-title"></span>
        <div class="task-actions">
          <button class="edit-btn" title="Edit task">
            <i class="bi bi-pencil"></i>
          </button>
          <button class="delete-btn" title="Delete task">
            <i class="bi bi-trash"></i>
          </button>
        </div>
      ;

      const checkbox = li.querySelector('.task-checkbox');
      const editBtn = li.querySelector('.edit-btn');
      const deleteBtn = li.querySelector('.delete-btn');

      checkbox.addEventListener('change', () => toggleTask(task.id, checkbox.checked));
      editBtn.addEventListener('click', () => startEdit(li, task));
      deleteBtn.addEventListener('click', () => deleteTask(task.id, li));

      return li;
    }

    function startEdit(li, task) {
      li.classList.add('editing');
      
      const titleSpan = li.querySelector('.task-title');
      const input = document.createElement('input');
      input.type = 'text';
      input.className = 'task-title-input';
      input.value = task.title;

      const actionsDiv = li.querySelector('.task-actions');
      
      const saveBtn = document.createElement('button');
      saveBtn.className = 'save-btn';
      saveBtn.innerHTML = '<i class="bi bi-check-lg"></i>';
      saveBtn.title = 'Save task';

      const cancelBtn = document.createElement('button');
      cancelBtn.className = 'cancel-btn';
      cancelBtn.innerHTML = '<i class="bi bi-x-lg"></i>';
      cancelBtn.title = 'Cancel';

      titleSpan.replaceWith(input);
      actionsDiv.innerHTML = '';
      actionsDiv.appendChild(saveBtn);
      actionsDiv.appendChild(cancelBtn);

      input.focus();
      input.select();

      const save = async () => {
        const newTitle = input.value.trim();
        if (!newTitle) {
          cancelEdit();
          return;
        }

        try {
          const response = await fetch(${API_URL}/, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title: newTitle, completed: task.completed })
          });

          if (!response.ok) throw new Error('Failed to update task');

          task.title = newTitle;
          cancelEdit();
          loadTasks();
        } catch (error) {
          console.error('Error updating task:', error);
          alert('Failed to update task');
        }
      };

      const cancelEdit = () => {
        input.replaceWith(titleSpan);
        li.classList.remove('editing');
        const newEditBtn = document.createElement('button');
        newEditBtn.className = 'edit-btn';
        newEditBtn.innerHTML = '<i class="bi bi-pencil"></i>';
        newEditBtn.title = 'Edit task';
        newEditBtn.addEventListener('click', () => startEdit(li, task));

        const newDeleteBtn = document.createElement('button');
        newDeleteBtn.className = 'delete-btn';
        newDeleteBtn.innerHTML = '<i class="bi bi-trash"></i>';
        newDeleteBtn.title = 'Delete task';
        newDeleteBtn.addEventListener('click', () => deleteTask(task.id, li));

        actionsDiv.innerHTML = '';
        actionsDiv.appendChild(newEditBtn);
        actionsDiv.appendChild(newDeleteBtn);
      };

      saveBtn.addEventListener('click', save);
      cancelBtn.addEventListener('click', cancelEdit);
      input.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') save();
        if (e.key === 'Escape') cancelEdit();
      });
      input.addEventListener('blur', cancelEdit);
    }

    async function toggleTask(id, completed) {
      try {
        const response = await fetch(${API_URL}/, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ completed })
        });

        if (!response.ok) throw new Error('Failed to update task');
      } catch (error) {
        console.error('Error toggling task:', error);
        loadTasks();
      }
    }

    async function addTask() {
      const title = newTaskInput.value.trim();
      if (!title) return;

      try {
        const response = await fetch(API_URL, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ title, completed: false })
        });

        if (!response.ok) throw new Error('Failed to create task');

        newTaskInput.value = '';
        loadTasks();
      } catch (error) {
        console.error('Error adding task:', error);
        alert('Failed to add task');
      }
    }

    async function deleteTask(id, li) {
      if (!confirm('Are you sure you want to delete this task?')) return;

      try {
        const response = await fetch(${API_URL}/, {
          method: 'DELETE'
        });

        if (!response.ok) throw new Error('Failed to delete task');

        li.remove();
        if (tasksList.children.length === 0) {
          tasksList.style.display = 'none';
          emptyState.style.display = 'block';
        }
      } catch (error) {
        console.error('Error deleting task:', error);
        alert('Failed to delete task');
      }
    }

    function escapeHtml(text) {
      const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '\"': '&quot;',
        "'": '&#039;'
      };
      return text.replace(/[&<>\"']/g, m => map[m]);
    }
  </script>
</body>
</html>
