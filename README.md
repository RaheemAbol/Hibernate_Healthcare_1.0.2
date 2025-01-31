# Healthcare_hibernate_1.0.2

### Ticket Breakdown: Healthcare Management System - Advanced Hibernate Relationships Implementation

This ticket breakdown will guide you through implementing advanced Hibernate relationships, such as one-to-one, many-to-one, one-to-many, and many-to-many associations in the Healthcare Management System. You'll also extend the existing functionality by adding new entities (like Office) and integrating these relationships into the existing application.

---

### **Ticket 1: Implement Office Class and OfficeRepository for One-to-One Relationship**

#### **Description:**
Implement the `Office` class and `OfficeRepositoryImpl` to manage office-related data, focusing on a one-to-one relationship between `Doctor` and `Office` using Hibernate.

#### **Tasks:**

1. **Create Office Model Class:**
   - **Path:** `com.healthcaremanagement.model`
   - **Class Name:** `Office`
   - **Attributes:**
     - `int officeId`: Represents the unique identifier for each office.
     - `String location`: The location of the office.
     - `String phone`: The office's phone number.
     - `Doctor doctor`: A reference to the `Doctor` associated with this office (one-to-one relationship).
   - **Hibernate Annotations:**
     - Use `@Entity` and `@Table(name = "Offices")` annotations to map the class to the `Offices` table.
     - Annotate `officeId` with `@Id` and `@GeneratedValue(strategy = GenerationType.IDENTITY)` to indicate the primary key.
     - Use `@Column` annotations for the `location` and `phone` fields to map them to their respective columns.
     - Use `@OneToOne` and `@JoinColumn(name = "DoctorID")` annotations to establish a one-to-one relationship with the `Doctor` entity.
   - **Use Lombock**
     - Implement getters and setters for each attribute.
     - Implement constructors
   - **Good to Know:**
     - **One-to-One Relationship:** Understand how Hibernate manages one-to-one relationships, especially with regard to foreign key constraints and cascading operations.

2. **Implement OfficeRepository:**
   - **Path:** `com.healthcaremanagement.repository`
   - **Class Name:** `OfficeRepositoryImpl`
   - **Methods:**
     - **Create Method:** `void createOffice(Office office)`
       - Use Hibernate’s `session.save(office)` method to insert a new office into the `Offices` table.
       - **Transaction:** Wrap the save operation in a transaction.
     - **Read Method:** `Office getOfficeById(int officeId)`
       - Use `session.get(Office.class, officeId)` to retrieve an office by ID.
     - **Update Method:** `void updateOffice(Office office)`
       - Use `session.update(office)` to update the existing office details.
       - **Transaction:** Wrap the update operation in a transaction.
     - **Delete Method:** `void deleteOffice(int officeId)`
       - Use `session.delete(office)` to remove an office from the database.
       - **Transaction:** Ensure the deletion is within a transaction.
     - **List All Method:** `List<Office> getAllOffices()`
       - Use HQL: `session.createQuery("from Office", Office.class).list()` to retrieve all offices.
   - **Good to Know:**
     - **Session Management:** Ensure that Hibernate sessions are opened and closed properly to avoid memory leaks.
     - **Cascading Operations:** Understand how cascading operations work in one-to-one relationships, especially when deleting or updating an entity.

3. **Test the Office Functionality:**
   - **Write simple test cases** or use the console to:
     - **Create:** Insert a new office record using `createOffice()`.
     - **Read:** Retrieve an office by ID using `getOfficeById()`.
     - **Update:** Modify an office’s details using `updateOffice()`.
     - **Delete:** Remove an office by ID using `deleteOffice()`.
     - **List All:** Retrieve all offices using `getAllOffices()`.

#### **Good to Know:**
   - **Testing Relationships:** Ensure that the one-to-one relationship between `Doctor` and `Office` is functioning as expected, particularly with cascading operations.
   - **Foreign Key Constraints:** Ensure that the `DoctorID` foreign key is properly maintained in the `Offices` table.

---

### **Ticket 2: Implement Relationships Between Entities (One-to-Many, Many-to-One, Many-to-Many)**

#### **Description:**
Implement the relationships between the `Doctor`, `Patient`, `Appointment`, and `Office` entities using Hibernate. This includes setting up one-to-many, many-to-one, and many-to-many associations.

#### **Tasks:**

1. **Update Doctor Class for Relationships:**
   - **One-to-Many Relationship with Appointments:**
     - Annotate the `appointments` field with `@OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)`.
   - **One-to-One Relationship with Office:**
     - Ensure the `office` field is correctly annotated with `@OneToOne(mappedBy = "doctor", cascade = CascadeType.ALL)`.
   - **Many-to-Many Relationship with Patients:**
     - Annotate the `patients` field with `@ManyToMany(cascade = {CascadeType.PERSIST},fetch = FetchType.LAZY)` and configure the `@JoinTable` accordingly.
   - **Good to Know:**
     - **MappedBy:** Understand the use of `mappedBy` in Hibernate to indicate the owner of the relationship.

2. **Update Patient Class for Relationships:**
   - **One-to-Many Relationship with Appointments:**
     - Annotate the `appointments` field with `@OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, fetch = FetchType.LAZY)`.
   - **Many-to-Many Relationship with Doctors:**
     - Annotate the `doctors` field with `@ManyToMany(mappedBy = "patients",cascade = {CascadeType.PERSIST}, fetch = FetchType.LAZY)`.
   - **Good to Know:**
     - **Lazy Loading:** Understand how `fetch = FetchType.LAZY` works in Hibernate and when to use it.

3. **Update Appointment Class for Relationships:**
   - **Many-to-One Relationship with Doctor:**
     - Annotate the `doctor` field with `@ManyToOne` and `@JoinColumn(name = "DoctorID")`.
   - **Many-to-One Relationship with Patient:**
     - Annotate the `patient` field with `@ManyToOne` and `@JoinColumn(name = "PatientID")`.
   - **Good to Know:**
     - **Bidirectional Relationships:** Ensure that both sides of the relationship (e.g., `Doctor` ↔ `Appointment`) are correctly mapped and consistent.

4. **Test the Relationships:**
     - **One-to-Many:** A doctor can have multiple appointments, and deleting a doctor cascades to delete all associated appointments.
     - **Many-to-Many:** A patient can be associated with multiple doctors and vice versa, and changes are reflected in the junction table (`Doctor_Patient`).
     - **One-to-One:** Deleting an office or a doctor should correctly handle the one-to-one relationship.

#### **Good to Know:**
   - **Cascading:** Understand how cascading operations (e.g., `CascadeType.ALL`) affect related entities in a relationship.
   - **Join Tables:** Ensure that many-to-many relationships are correctly mapped using join tables.

---

---

### **Ticket 3: Implement Helper Methods in Repositories**
#### **Tasks**
1. **In `DoctorRepositoryImpl` Implement `addPatientToDoctor(int doctorId, Patient patient)`**
   ```java
   public void addPatientToDoctor(int doctorId, Patient patient) {
       try (Session session = sessionFactory.openSession()) {
           Transaction transaction = session.beginTransaction();
           Doctor doctor = session.get(Doctor.class, doctorId);
           if (doctor != null && !doctor.getPatients().contains(patient)) {
               doctor.getPatients().add(patient);
               session.merge(doctor);
           }
           transaction.commit();
       }
   }
   ```

2. ** In `DoctorRepositoryImpl` Implement `removePatientFromDoctor(int doctorId, Patient patient)`**
   ```java
   public void removePatientFromDoctor(int doctorId, Patient patient) {
       try (Session session = sessionFactory.openSession()) {
           Transaction transaction = session.beginTransaction();
           Doctor doctor = session.get(Doctor.class, doctorId);
           if (doctor != null && doctor.getPatients().contains(patient)) {
               doctor.getPatients().remove(patient);
               session.merge(doctor);
           }
           transaction.commit();
       }
   }
   ```
3. **The reverse of addPatientToDoctor() && removePatientFromDoctor() need to be implemented in PatientRepositroyImpl** 
   `addDoctorToPatient(int patientId, Doctor doctor) && removeDoctorFromPatient(int patientId, Doctor doctor)`


4. **In `AppointmentRepositoryImpl` Implement `hasOtherAppointmentsBetween()`**
   ```java
   public boolean hasOtherAppointmentsBetween(int doctorId, int patientId) {
       try (Session session = sessionFactory.openSession()) {
           String query = "SELECT COUNT(a) FROM Appointment a " +
                   "WHERE a.doctor.doctorId = :doctorId " +
                   "AND a.patient.patientId = :patientId";
           Long count = session.createQuery(query, Long.class)
                   .setParameter("doctorId", doctorId)
                   .setParameter("patientId", patientId)
                   .uniqueResult();
           return count != null && count > 1;
       }
   }
   ```
5. **Make sure these newly implemented methods are reflected inside of your services.**
---


### **Ticket 4: Refactor HealthRunner Class to Include Office Management**

#### **Description:**
Refactor the `HealthRunner` class to include options for managing offices in addition to patients, doctors, and appointments.

#### **Tasks:**

1. **Update the Main Menu:**
   - **In the `HealthRunner` class, update the main menu** to include an option for managing offices.
   - **Menu Example:**
     - Manage Patients
     - Manage Doctors
     - Manage Appointments
     - Manage Offices
   - **Good to Know:**
     - **Navigation:** Ensure that the user can navigate back to the main menu after performing operations.

2. **Implement `manageOffices()` Method:**
   - **Add a new method** `private static void manageOffices(OfficeService officeService, Scanner scanner)` to handle CRUD operations for offices.
   - **Sub-Menu Options:**
     - Create a new office.
     - Read an office’s details by ID.
     - Update an office’s details.
     - Delete an office by ID.
     - List all offices.
   - **Good to Know:**
     - **Service Layer:** Use the `OfficeService` to interact with the `OfficeRepository` and handle business logic.

3. **Integrate the `manageOffices()` Method:**
   - **In the main switch statement** inside the `HealthRunner` class, integrate the `manageOffices()` method so it is invoked based on the user's menu choice.
   - **Ensure that selecting “4”** from the main menu navigates to the office management sub-menu.

4. **Test the Office Management Functionality:**
   - **Run the application and test each menu option** to ensure they navigate correctly to the sub-menus.
   - **Test CRUD operations** for the `Office` entity to ensure everything works as expected.

#### **Good to Know:**
   - **Error Handling:** Add error handling to manage invalid IDs or operations that fail due to database constraints.
   - **User Feedback:** Provide clear feedback to the user after each operation, such as confirmation messages for successful creation, updates, or deletion.

---

---

## **Ticket 5: Refactor `HealthRunner` Class to Use Relationship Methods**
### **Step 1: Modify the `manageAppointments()` method signiture to manageAppointments(appointmentService, patientService, doctorService, scanner)**
- Modify **Create Appointment**:
  ```java
  doctorService.addPatientToDoctor(doctorId, patient);
  patientService.addDoctorToPatient(patientId, doctor);
  ```

- Modify **Update Appointment**:
  ```java
  if (!appointmentService.hasOtherAppointmentsBetween(
          originalDoctor.getDoctorId(), originalPatient.getPatientId())) {
      doctorService.removePatientFromDoctor(originalDoctor.getDoctorId(), originalPatient);
      patientService.removeDoctorFromPatient(originalPatient.getPatientId(), originalDoctor);
  }
  ```

- Modify **Delete Appointment**:
  ```java
  if (!appointmentService.hasOtherAppointmentsBetween(
          doctorToCheck.getDoctorId(), patientToCheck.getPatientId())) {
      doctorService.removePatientFromDoctor(doctorToCheck.getDoctorId(), patientToCheck);
      patientService.removeDoctorFromPatient(patientToCheck.getPatientId(), doctorToCheck);
  }
  ```

---

### **Final Notes:**

- **Annotations:** Pay attention to Hibernate annotations (`@Entity`,`@Table`, `@Id`, `@OneToOne`, `@ManyToMany`, etc.) to ensure proper mapping between your model classes and the database tables.
- **Transactions:** Always use transactions for create, update, and delete operations to maintain data integrity.
- **Session Management:** Properly manage Hibernate sessions to avoid memory leaks and ensure efficient use of database connections.
- **Testing:** Test each functionality thoroughly to ensure that the application behaves as expected and interacts correctly with the database.
