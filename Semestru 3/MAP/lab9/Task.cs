namespace Lab1MAP_BUN
{
    using System;

    public abstract class Task
    {
        private string taskID, descriere;

        public Task(string taskID)
        {
            this.taskID = taskID;
        }

        public string TaskID
        {
            get { return taskID; }
            set { taskID = value; }
        }

        public string Descriere
        {
            get { return descriere; }
            set { descriere = value; }
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(this, obj)) return true;
            if (obj == null || GetType() != obj.GetType()) return false;
        
            Task task = (Task)obj;
            return taskID == task.taskID && descriere == task.descriere;
        }

        public override int GetHashCode()
        {
            // Combine the hash codes of taskID and descriere
            int hash = 17;
            hash = hash * 23 + (taskID?.GetHashCode() ?? 0);  // Handle null for taskID
            hash = hash * 23 + (descriere?.GetHashCode() ?? 0);  // Handle null for descriere
            return hash;
        }


        public override string ToString()
        {
            return $"Task{{taskID='{taskID}', descriere='{descriere}'}}";
        }

        public abstract void Execute();
    }

}