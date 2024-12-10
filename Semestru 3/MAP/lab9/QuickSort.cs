using System;

namespace Lab1MAP_BUN
{
    
    public class QuickSort : AbstractSorter
    {
        public override void Sort(int[] array)
        {
            Console.WriteLine(">Sorting with QuickSort");
            QuickSortRecursive(array, 0, array.Length - 1);
        }

        private void QuickSortRecursive(int[] array, int low, int high)
        {
            if (low < high)
            {
                int pi = Partition(array, low, high);
                QuickSortRecursive(array, low, pi - 1);
                QuickSortRecursive(array, pi + 1, high);
            }
        }

        private int Partition(int[] array, int low, int high)
        {
            int pivot = array[high];
            int i = low - 1;
            for (int j = low; j < high; j++)
            {
                if (array[j] <= pivot)
                {
                    i++;
                    int temp = array[i];
                    array[i] = array[j];
                    array[j] = temp;
                }
            }
            int temp2 = array[i + 1];
            array[i + 1] = array[high];
            array[high] = temp2;
            return i + 1;
        }
    }

}