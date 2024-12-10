using System;

namespace Lab1MAP_BUN
{
    public class SortingTask : Task
    {
        private AbstractSorter sorter;
        private int[] array;

        public SortingTask(string taskID, AbstractSorter sorter, int[] array) : base(taskID)
        {
            this.sorter = sorter;
            this.array = array;
        }

        public override void Execute()
        {
            PrintArray(array);

            sorter.Sort(array);  

            PrintArray(array);
        }

        private void PrintArray(int[] array)
        {
            foreach (int num in array)
            {
                Console.Write(num + " ");
            }
            Console.WriteLine();
        }
    }

}