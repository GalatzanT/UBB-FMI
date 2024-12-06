package repository.memory;

import domain.Entity;
import domain.validators.ValidationException;
import domain.validators.Validator;
import repository.Repository;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class InMemoryRepository<ID, E extends Entity<ID>> implements Repository<ID, E> {

    private Validator<E> validator;
    protected Map<ID, E> entities;

    public InMemoryRepository(Validator<E> validator) {
        this.validator = validator;
        this.entities = new HashMap<>();
    }

    @Override
    public Optional<E> findOne(ID id) {
        if (id == null) {
            throw new IllegalArgumentException("id can't be null");
        }
        return Optional.ofNullable(entities.get(id));
    }

    @Override
    public Iterable<E> findAll() {
        return entities.values();
    }

    @Override
    public Optional<E> save(E entity) throws ValidationException {
        if (entity == null) {
            throw new IllegalArgumentException("ENTITY CANNOT BE NULL");
        }
        validator.validate(entity);
        if (entities.containsKey(entity.getId())) {
            return Optional.of(entity); // Returnăm entitatea existentă dacă ID-ul există deja
        } else {
            entities.put(entity.getId(), entity);
            return Optional.empty(); // Returnăm Optional.empty() dacă salvarea a fost reușită
        }
    }

    @Override
    public Optional<E> delete(ID id) {
        if (id == null) {
            throw new IllegalArgumentException("ID can't be NULL");
        }
        return Optional.ofNullable(entities.remove(id)); // Returnăm entitatea eliminată sau Optional.empty()
    }

    @Override
    public Optional<E> update(E entity) {
        if (entity == null) {
            throw new IllegalArgumentException("Entity cannot be null");
        }
        if (entities.containsKey(entity.getId())) {
            entities.put(entity.getId(), entity); // Înlocuim entitatea existentă
            return Optional.empty(); // Returnăm Optional.empty() dacă actualizarea a fost reușită
        } else {
            return Optional.of(entity); // Returnăm entitatea dacă ID-ul nu există
        }
    }
}
