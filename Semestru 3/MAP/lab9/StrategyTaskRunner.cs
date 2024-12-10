namespace Lab1MAP_BUN
{
    public class StrategyTaskRunner : TaskRunner
    {
        private Container container;

        public StrategyTaskRunner(Strategy strategy)
        {
            container = TaskContainerFactory.GetInstance().CreateContainer(strategy);
        }

        public void ExecuteOneTask()
        {
            Task t = container.Remove();
            t.Execute();
        }

        public void ExecuteAll()
        {
            while (HasTask())
            {
                ExecuteOneTask();
            }
        }

        public void AddTask(Task t)
        {
            container.Add(t);
        }

        public bool HasTask()
        {
            return !container.IsEmpty();
        }
    }

}