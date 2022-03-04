import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewAssignment extends StatefulWidget {
  final Function addAssignment;
  NewAssignment(this.addAssignment);

  @override
  State<NewAssignment> createState() => _NewAssignmentState();
}

class _NewAssignmentState extends State<NewAssignment> {
  final textEditingController = TextEditingController();
  DateTime? selectedDate;
  DateTime? selectedTime;
  void submitData() {
    final enteredTitle = textEditingController.text;
    if (enteredTitle.isEmpty || _time==null) {
      return;
    }
    widget.addAssignment(context,enteredTitle, selectedDate,_time);
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(3000))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = value;
      });
    });
  }

  TimeOfDay? _time ;

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: textEditingController,
                onSubmitted: (value) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(selectedDate as DateTime)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: presentDatePicker,
                    )
                  ],
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _time == null
                            ? 'No Time Chosen!'
                            : 'Picked Time: ${_time!.format(context)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _selectTime,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    child: Text('Add Assignment'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: submitData,
                  ),
                  RaisedButton(
                      child: Text('Cancel'),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              )
            ],
          ),
        ));
  }
}
