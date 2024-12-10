namespace Lab1MAP_BUN
{
    using System.Collections.Generic;

    using System.Collections.Generic;

    public abstract class AbstractTaskContainer : Container
    {
        protected List<Task> tasks = new List<Task>();

        public void Add(Task task)
        {
            tasks.Add(task);
        }

        public int Size()
        {
            return tasks.Count;
        }

        public bool IsEmpty()
        {
            return tasks.Count == 0;
        }

        // Abstract method for removing a task
        public abstract Task Remove();
    }


}