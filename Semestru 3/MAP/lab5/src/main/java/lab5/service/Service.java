package lab5.service;

import lab5.domain.Prietenie;
import lab5.domain.Utilizator;
import lab5.domain.validators.PrietenieValidator;
import lab5.domain.validators.UtilizatorValidator;
import lab5.repository.database.UtilizatorDbRepository;
import lab5.repository.file.PrietenieRepository;
import lab5.repository.file.UtilizatorRepository;
import lab5.repository.database.*;
import java.util.*;

public class Service {
    private static Service instance;
    private final PrietenieDbRepository prietenieRepo;
    private final UtilizatorDbRepository utilizatorRepo;

//    public Service() {
//        this.utilizatorRepo = new UtilizatorRepository(new UtilizatorValidator(), "utilizatori.txt");
//        this.prietenieRepo = new PrietenieRepository(new PrietenieValidator(), "prietenii.txt");
//      loadData();
//    }

    public Service(){
        String username="postgres";
        String pasword="postgres";
        String url="jdbc:postgresql://localhost:6969/MetGala";
        this.utilizatorRepo = new UtilizatorDbRepository(url,username, pasword,  new UtilizatorValidator());
        this.prietenieRepo = new PrietenieDbRepository(url,username, pasword, new PrietenieValidator());
    }

    // Singleton pattern implementation
    public static Service getInstance() {
        if (instance == null) {
            instance = new Service();
        }
        return instance;
    }

    private void loadData() {
        try {
            // Încarcă datele din fișiere la pornirea serviciului
            utilizatorRepo.findAll();
            prietenieRepo.findAll();
        } catch (RuntimeException e) {
            throw new ServiceException("Error loading data: " + e.getMessage());
        }
    }
    public Iterable<Utilizator> getAllUtilizatori() {
        return utilizatorRepo.findAll();
    }
    // Metode pentru Utilizatori
    public Utilizator addUtilizator(String firstName, String lastName) {
        utilizatorRepo.findAll().forEach(user -> {
            if (user.getFirstName().equals(firstName) && user.getLastName().equals(lastName)) {
                throw new ServiceException("Exista un user cu acest nume!");
            }
        });
        Utilizator user = new Utilizator(firstName, lastName);
        user.setId(generateNextUserId());
        Optional<Utilizator> result = utilizatorRepo.save(user);
        if (result.isPresent()) {
            throw new ServiceException("User already exists!");
        }
        return user;
    }

    public Utilizator deleteUtilizator(Long id) {
        // Șterge utilizatorul
        Optional<Utilizator> deleted = utilizatorRepo.delete(id);
        Utilizator utilizator = deleted.orElseThrow(() -> new ServiceException("User does not exist!"));

        // Șterge toate prieteniile asociate utilizatorului
        List<Prietenie> prieteniiDeSters = new ArrayList<>();
        prietenieRepo.findAll().forEach(prietenie -> {
            if (prietenie.getIdU1().equals(id) || prietenie.getIdU2().equals(id)) {
                prieteniiDeSters.add(prietenie);
            }
        });

        // Folosim metoda deletePrietenie pentru a șterge fiecare prietenie
        prieteniiDeSters.forEach(prietenie -> deletePrietenie(prietenie.getId()));

        return utilizator;
    }

    // Metode pentru Prietenii
    public Prietenie addPrietenie(Long id1, Long id2) {
        prietenieRepo.findAll().forEach(prietenie -> {
            if (prietenie.getIdU1().equals(id1) && prietenie.getIdU2().equals(id2) ||
                    prietenie.getIdU1().equals(id2) && prietenie.getIdU2().equals(id1)) {
                throw new ServiceException("Exista o prietenie intre acesti 2 useri");
            }
        });
        if (id1.equals(id2)) {
            throw new ServiceException("Users cannot be friends with themselves!");
        }

        Utilizator user1 = utilizatorRepo.findOne(id1).orElseThrow(() -> new ServiceException("User1 does not exist!"));
        Utilizator user2 = utilizatorRepo.findOne(id2).orElseThrow(() -> new ServiceException("User2 does not exist!"));

        Prietenie prietenie = new Prietenie(id1, id2);
        prietenie.setId(generateNextFriendshipID());
        Optional<Prietenie> result = prietenieRepo.save(prietenie);
        if (result.isPresent()) {
            throw new ServiceException("Friendship already exists!");
        }
        return prietenie;
    }

    public Prietenie deletePrietenie(Long id) {
        return prietenieRepo.delete(id).orElseThrow(() -> new ServiceException("Friendship does not exist!"));
    }

    public Iterable<Prietenie> getAllPrietenii() {
        return prietenieRepo.findAll();
    }

    private Long generateNextUserId() {
        Long maxId = 0L;
        for (Utilizator user : utilizatorRepo.findAll()) {
            if (user.getId() > maxId) {
                maxId = user.getId();
            }
        }
        return maxId + 1;
    }

    public Utilizator updateUtilizator(Long id, String firstName, String lastName) {
        // Verificăm dacă utilizatorul există
        Utilizator utilizatorExistent = utilizatorRepo.findOne(id)
                .orElseThrow(() -> new ServiceException("Utilizatorul cu ID-ul " + id + " nu există!"));

        // Actualizăm datele utilizatorului
        utilizatorExistent.setFirstName(firstName);
        utilizatorExistent.setLastName(lastName);

        // Salvăm modificările
        Optional<Utilizator> result = utilizatorRepo.update(utilizatorExistent);
        if (result.isPresent()) {
            throw new ServiceException("Actualizarea a eșuat! Poate utilizatorul există deja cu aceste date.");
        }

        return utilizatorExistent;
    }


    private long generateNextFriendshipID() {
        Long maxID = 0L;
        for (Prietenie p : prietenieRepo.findAll()) {
            if (p.getId() > maxID)
                maxID = p.getId();
        }
        return maxID + 1;
    }
    public int getNumberOfCommunities() {
        Set<Long> visitedUsers = new HashSet<>();
        int communityCount = 0;

        for (Utilizator user : utilizatorRepo.findAll()) {
            if (!visitedUsers.contains(user.getId())) {
                // Start a new DFS for an unvisited user
                dfs(user.getId(), visitedUsers);
                communityCount++;
            }
        }

        return communityCount;
    }

    public List<Long> getMostSociableCommunity() {
        Set<Long> visitedUsers = new HashSet<>();
        List<Long> mostSociableCommunity = new ArrayList<>();
        int maxPathLength = 0;

        for (Utilizator user : utilizatorRepo.findAll()) {
            if (!visitedUsers.contains(user.getId())) {
                List<Long> currentCommunity = new ArrayList<>();
                int currentPathLength = findLongestPath(user.getId(), visitedUsers, currentCommunity);

                if (currentPathLength > maxPathLength) {
                    maxPathLength = currentPathLength;
                    mostSociableCommunity = currentCommunity;
                }
            }
        }

        return mostSociableCommunity;
    }

    // Helper method for DFS traversal
    private void dfs(Long userId, Set<Long> visitedUsers) {
        visitedUsers.add(userId);

        for (Prietenie friendship : prietenieRepo.findAll()) {
            Long friendId = null;
            if (friendship.getIdU1().equals(userId) && !visitedUsers.contains(friendship.getIdU2())) {
                friendId = friendship.getIdU2();
            } else if (friendship.getIdU2().equals(userId) && !visitedUsers.contains(friendship.getIdU1())) {
                friendId = friendship.getIdU1();
            }

            if (friendId != null) {
                dfs(friendId, visitedUsers);
            }
        }
    }

    // Helper method to find the longest path in a community
    private int findLongestPath(Long startUserId, Set<Long> visitedUsers, List<Long> communityUsers) {
        Map<Long, Integer> distances = new HashMap<>();
        Queue<Long> queue = new LinkedList<>();

        distances.put(startUserId, 0);
        queue.add(startUserId);
        visitedUsers.add(startUserId);
        communityUsers.add(startUserId);

        int maxPathLength = 0;

        while (!queue.isEmpty()) {
            Long currentUserId = queue.poll();

            for (Prietenie friendship : prietenieRepo.findAll()) {
                Long neighborId = null;
                if (friendship.getIdU1().equals(currentUserId) && !visitedUsers.contains(friendship.getIdU2())) {
                    neighborId = friendship.getIdU2();
                } else if (friendship.getIdU2().equals(currentUserId) && !visitedUsers.contains(friendship.getIdU1())) {
                    neighborId = friendship.getIdU1();
                }

                if (neighborId != null) {
                    int newDistance = distances.get(currentUserId) + 1;
                    distances.put(neighborId, newDistance);
                    queue.add(neighborId);
                    visitedUsers.add(neighborId);
                    communityUsers.add(neighborId);

                    if (newDistance > maxPathLength) {
                        maxPathLength = newDistance;
                    }
                }
            }
        }

        return maxPathLength;
    }
}


