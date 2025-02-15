
import 'dart:io';

import 'package:SewerBaghdad/models/notificationSlider.dart';
import 'package:SewerBaghdad/models/posts.dart';
import 'package:SewerBaghdad/repastory/postsRepastory.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




abstract class PostsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {
 
  FetchPosts();
  
  @override
  List<Object> get props => [];
}


abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsUninitialized extends PostsState {}

class PostsLoading extends PostsState {}

class PostsError extends PostsState {
  final string;
  PostsError(this.string);
}

class PostsNetworkError extends PostsState {}

class PostsLoaded extends PostsState {
  final PostsModel banners;
final NotificationModel notifications;
  PostsLoaded({this.banners,this.notifications});

 PostsLoaded copyWith({
    PostsModel banners,
    NotificationModel notifications
  }) {
    return PostsLoaded(
      banners: banners ?? this.banners,notifications:notifications ??this.notifications
    );
  }
  @override
  List<Object> get props => [banners, notifications];
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepastory Repo;

  PostsBloc({@required this.Repo}) : super(PostsLoading());


  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    final currentState = state;
    if (event is FetchPosts) {
      
      try {
     
          yield PostsLoading();
          
          final banners = await Repo.getBanners();
          final notifications = await Repo.getNotification();

          yield PostsLoaded( banners:banners,notifications:notifications);
          return;
        
      } on SocketException catch (_) {
        yield PostsNetworkError();
      }catch(_){
          yield PostsError(_.toString());
       
      
         //print("error "+_);
      }
    }}
  }
