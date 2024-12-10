namespace Lab1MAP_BUN
{
    public interface Container
    {
        Task Remove();
        void Add(Task task);
        int Size();
        bool IsEmpty();
    }

}