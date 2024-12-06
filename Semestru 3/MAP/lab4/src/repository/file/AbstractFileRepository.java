package repository.file;

import domain.Entity;
import domain.validators.Validator;
import repository.memory.InMemoryRepository;

import java.io.*;
import java.util.Optional;

public abstract class AbstractFileRepository<ID, E extends Entity<ID>> extends InMemoryRepository<ID, E> {
    private String filename;

    public AbstractFileRepository(Validator<E> validator, String fileName) {
        super(validator);
        this.filename = fileName;
        loadData();
    }

    protected void loadData() {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = reader.readLine()) != null && !line.trim().isEmpty()) {
                E entity = createEntity(line);
                super.save(entity);
            }
        } catch (IOException e) {
            // Creăm fișierul dacă nu există
            try {
                new File(filename).createNewFile();
            } catch (IOException ex) {
                throw new RuntimeException("Error creating file " + filename);
            }
        }
    }

    public abstract E createEntity(String line);
    public abstract String saveEntity(E entity);

    @Override
    public Optional<E> findOne(ID id) {
        return super.findOne(id);
    }

    @Override
    public Iterable<E> findAll() {
        return super.findAll();
    }

    @Override
    public Optional<E> save(E entity) {
        Optional<E> optionalEntity = super.save(entity);
        if (optionalEntity.isEmpty()) {
            writeToFile();
        }
        return optionalEntity;
    }

    @Override
    public Optional<E> delete(ID id) {
        Optional<E> optionalEntity = super.delete(id);
        if (optionalEntity.isPresent()) {
            writeToFile();
        }
        return optionalEntity;
    }

    @Override
    public Optional<E> update(E entity) {
        Optional<E> optionalEntity = super.update(entity);
        if (optionalEntity.isEmpty()) {
            writeToFile();
        }
        return optionalEntity;
    }

    protected void writeToFile() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
            for (E entity : entities.values()) {
                writer.write(saveEntity(entity));
                writer.newLine();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
