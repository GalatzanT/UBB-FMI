namespace Lab1MAP_BUN
{
    public interface TaskRunner
    {
        void ExecuteOneTask();
        void ExecuteAll();
        void AddTask(Task t);
        bool HasTask();
    }

}