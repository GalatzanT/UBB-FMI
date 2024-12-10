namespace Lab1MAP_BUN
{
    using System.Collections.Generic;

    public class StackContainer : AbstractTaskContainer
    {
        public override Task Remove()
        {
            if (tasks.Count == 0)
            {
                return null;
            }
            // Return and remove the last element (LIFO)
            Task lastTask = tasks[tasks.Count - 1];
            tasks.RemoveAt(tasks.Count - 1);
            return lastTask;
        }
    }

}