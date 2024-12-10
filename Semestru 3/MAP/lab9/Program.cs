using System;
using System.Linq;

namespace Lab1MAP_BUN
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] v1 = { 64, 34, 25, 12, 22, 11, 90 };
            SortingTask bubbleSortTask = new SortingTask("1", new BubbleSort(), v1);
            bubbleSortTask.Execute();

            int[] v2 = { 64, 34, 25, 12, 22, 11, 90 };
            SortingTask quickSortTask = new SortingTask("2", new QuickSort(), v2);
            quickSortTask.Execute();

            // Creating an array of MessageClass tasks
            MessageClass[] tasks = new MessageClass[5];
            tasks[0] = new MessageClass("1", "Task1", "Send Email", "ana", "tudor", DateTime.Now);
            tasks[1] = new MessageClass("2", "Task2", "Generate Report", "maria", "buo", DateTime.Now);
            tasks[2] = new MessageClass("3", "Task3", "Backup Database", "a", "ca", DateTime.Now);
            tasks[3] = new MessageClass("4", "Task4", "Deploy Application", "b", "c", DateTime.Now);
            tasks[4] = new MessageClass("5", "Task5", "Run Tests", "a", "d", DateTime.Now);

            // Displaying tasks
            foreach (var task in tasks)
            {
                Console.WriteLine(task);
            }

            Strategy strategy;
            try
            {
                strategy = (Strategy)Enum.Parse(typeof(Strategy), args[0], true);
            }
            catch (ArgumentException)
            {
                Console.Error.WriteLine("Not FIFO or LIFO strategy.");
                return;
            }

            TaskRunner strategyTaskRunner = new StrategyTaskRunner(strategy);

            foreach (var task in tasks)
            {
                strategyTaskRunner.AddTask(task);
            }

            PrinterTaskRunner printerTaskRunner = new PrinterTaskRunner(strategyTaskRunner);
            DelayTaskRunner delayTaskRunner = new DelayTaskRunner(printerTaskRunner);

            delayTaskRunner.ExecuteAll();
        }
    }
}
