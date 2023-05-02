//
//  TaskViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-20.
//

import UIKit
import Firebase
import FirebaseFirestore


class TaskViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let completedDatesCollection = Firestore.firestore().collection("completedDates")
    var completedDates = [Date]()
    var selectedDate = Date()
    var totalSquares = [String]()
    var update: (() -> Void)?
    var task: String?
    var currentPosition: Int = 0
    var documentID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCellsView()
        setMonthView()
        
    }
        
        override func viewDidAppear(_ animated: Bool) {
               super.viewDidAppear(animated)

               // Fetch completed dates from Firestore
               completedDatesCollection.getDocuments { [weak self] (snapshot, error) in
                   guard let self = self else { return }

                   if let documents = snapshot?.documents {
                       self.completedDates = documents.compactMap { $0.data()["date"] as? Timestamp }.map { $0.dateValue() }
                   }

                   // Reload the collection view to update the calendar cells
                   self.collectionView.reloadData()
               }
           }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {

        let currentDate = Date()
                completedDates.append(currentDate)

                // Save completed date to Firestore
                completedDatesCollection.addDocument(data: ["date": Timestamp(date: currentDate)])

                // Reload the collection view to update the calendar cells
                collectionView.reloadData()
           
       }
    
    
   
    
    func setCellsView() {
        
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        
    }
    
    func setMonthView() {
        
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while (count <= 42){
            
            if (count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
            
        }
        monthLabel.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell

        cell.dayOfMonth.text = totalSquares[indexPath.item]

        let currentDate = Calendar.current.startOfDay(for: selectedDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let cellDateText = cell.dayOfMonth.text,
           let cellDate = dateFormatter.date(from: "\(CalendarHelper().yearString(date: selectedDate))-\(CalendarHelper().monthString(date: selectedDate))-\(cellDateText)") {
            let isCompleted = completedDates.contains { completedDate in
                return Calendar.current.isDate(completedDate, inSameDayAs: cellDate)
            }

            if isCompleted {
                cell.backgroundColor = .green
            } else {
                cell.backgroundColor = .white
            }
        } else {
            cell.backgroundColor = .white
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        totalSquares.count
        
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool {
        
        return false
        }
    }





    


