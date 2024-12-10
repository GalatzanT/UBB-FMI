using System;

namespace Lab1MAP_BUN
{
    public class BubbleSort : AbstractSorter
    {
        public override void Sort(int[] array)
        {
            Console.WriteLine(">Sorting with Bubble sort");
            int n = array.Length;
            bool swapped;
            for (int i = 0; i < n - 1; i++)
            {
                swapped = false;
                for (int j = 0; j < n - i - 1; j++)
                {
                    if (array[j] > array[j + 1])
                    {
                        int temp = array[j];
                        array[j] = array[j + 1];
                        array[j + 1] = temp;
                        swapped = true;
                    }
                }
                if (!swapped)
                    break;
            }
        }
    }

}