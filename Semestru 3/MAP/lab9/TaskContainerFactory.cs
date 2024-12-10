namespace Lab1MAP_BUN
{
    public class TaskContainerFactory : Factory
    {
        // Private static instance
        private static TaskContainerFactory instance;

        // Private constructor to prevent external instantiation
        private TaskContainerFactory() { }

        // Public static method to get the singleton instance
        public static TaskContainerFactory GetInstance()
        {
            if (instance == null)
            {
                instance = new TaskContainerFactory();
            }
            return instance;
        }

        // Method to create a container based on the strategy
        public Container CreateContainer(Strategy strategy)
        {
            switch (strategy)
            {
                case Strategy.LIFO:
                    return new StackContainer();
                case Strategy.FIFO:
                    return new QueueContainer();
                default:
                    return null;
            }
        }
    }

}