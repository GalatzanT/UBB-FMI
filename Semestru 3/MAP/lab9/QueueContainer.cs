namespace Lab1MAP_BUN
{
    using System.Collections.Generic;

    public class QueueContainer : AbstractTaskContainer
    {
        public override Task Remove()
        {
            if (tasks.Count == 0)
            {
                return null;
            }
            // Return and remove the first element (FIFO)
            Task firstTask = tasks[0];
            tasks.RemoveAt(0);
            return firstTask;
        }
    }

}