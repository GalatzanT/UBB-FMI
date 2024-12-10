namespace Lab1MAP_BUN
{
    public abstract class AbstractTaskRunner : TaskRunner
    {
        private readonly TaskRunner _taskRunner;

        public AbstractTaskRunner(TaskRunner taskRunner)
        {
            _taskRunner = taskRunner;
        }


        public virtual void ExecuteOneTask()
        {
            _taskRunner.ExecuteOneTask();
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
            _taskRunner.AddTask(t);
        }

        public bool HasTask()
        {
            return _taskRunner.HasTask();
        }
    }


}